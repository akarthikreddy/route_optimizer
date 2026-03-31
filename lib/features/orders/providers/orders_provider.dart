import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/woo_order.dart';
import '../services/woocommerce_service.dart';
import '../../config/providers/config_provider.dart';

part 'orders_provider.g.dart';

@riverpod
Future<WooCommerceService> wooCommerceService(Ref ref) async {
  final wooConfig = await ref.watch(wooConfigProvider.future);
  return WooCommerceService(
    baseUrl: wooConfig.baseUrl,
    consumerKey: wooConfig.consumerKey,
    consumerSecret: wooConfig.consumerSecret,
  );
}

/// All processing orders from WooCommerce (unfiltered).
@riverpod
Future<List<WooOrder>> orders(Ref ref) async {
  final service = await ref.watch(wooCommerceServiceProvider.future);
  return service.fetchProcessingOrders();
}

/// All unique delivery slots found across all orders, sorted chronologically.
@riverpod
Future<List<String>> availableSlots(Ref ref) async {
  final allOrders = await ref.watch(ordersProvider.future);
  final slots = allOrders
      .map((o) => o.deliverySlot)
      .where((s) => s.isNotEmpty)
      .toSet()
      .toList();
  slots.sort((a, b) => _slotSortKey(a).compareTo(_slotSortKey(b)));
  return slots;
}

/// The nearest upcoming slot (today or first future slot).
@riverpod
Future<String?> nearestSlot(Ref ref) async {
  final slots = await ref.watch(availableSlotsProvider.future);
  if (slots.isEmpty) return null;
  final now = DateTime.now();
  for (final slot in slots) {
    final dt = _parseSlotDate(slot);
    if (dt != null && !dt.isBefore(DateTime(now.year, now.month, now.day))) {
      return slot;
    }
  }
  return slots.first;
}

/// Selected slots for filtering. Empty set = show all orders.
@riverpod
class SelectedSlots extends _$SelectedSlots {
  @override
  Set<String> build() => {};

  void toggle(String slot) {
    final next = Set<String>.from(state);
    if (next.contains(slot)) {
      next.remove(slot);
    } else {
      next.add(slot);
    }
    state = next;
  }

  void selectOnly(String slot) => state = {slot};
  void selectAll(List<String> slots) => state = Set.from(slots);
  void clearAll() => state = {};
}

/// Whether the slot filter has been initialised with the nearest slot.
@riverpod
class SlotInitialised extends _$SlotInitialised {
  @override
  bool build() => false;
  void markDone() => state = true;
}

/// Orders filtered by selected slots (empty set = all orders).
@riverpod
Future<List<WooOrder>> filteredOrders(Ref ref) async {
  final allOrders = await ref.watch(ordersProvider.future);
  final selected = ref.watch(selectedSlotsProvider);
  final initialised = ref.watch(slotInitialisedProvider);

  // Auto-select nearest slot on first load.
  if (!initialised) {
    final nearest = await ref.watch(nearestSlotProvider.future);
    Future.microtask(() {
      if (nearest != null) {
        ref.read(selectedSlotsProvider.notifier).selectOnly(nearest);
      }
      ref.read(slotInitialisedProvider.notifier).markDone();
    });
    if (nearest != null) {
      return allOrders.where((o) => o.deliverySlot == nearest).toList();
    }
    return allOrders;
  }

  if (selected.isEmpty) return allOrders;
  return allOrders.where((o) => selected.contains(o.deliverySlot)).toList();
}

// ── Slot sorting helpers ──────────────────────────────────────────────────────

String _slotSortKey(String slot) {
  final dt = _parseSlotDateTime(slot);
  return dt?.toIso8601String() ?? slot;
}

/// Parses date + start time from a slot key for chronological sorting.
DateTime? _parseSlotDateTime(String slot) {
  // slot key uses '|' separator (no spaces)
  final parts = slot.split('|');
  final datePart = parts.first.trim();
  final timePart = parts.length > 1 ? parts[1].trim() : '';

  final date = _parseDateOnly(datePart);
  if (date == null) return null;

  final minutes = _parseStartTimeMinutes(timePart);
  return date.add(Duration(minutes: minutes));
}

DateTime? _parseDateOnly(String raw) {
  // Split on / or - to get parts
  final parts = raw.split(RegExp(r'[/\-]'));
  if (parts.length == 3) {
    final a = int.tryParse(parts[0]);
    final b = int.tryParse(parts[1]);
    final c = int.tryParse(parts[2]);
    if (a != null && b != null && c != null) {
      if (c > 31) {
        // DD-MM-YYYY or MM/DD/YYYY — assume DD-MM-YYYY for India
        return DateTime.tryParse(
            '$c-${b.toString().padLeft(2, '0')}-${a.toString().padLeft(2, '0')}');
      } else if (a > 31) {
        // YYYY-MM-DD
        return DateTime.tryParse(raw);
      }
    }
  }
  return DateTime.tryParse(raw);
}

/// Parses start time from strings like "6AM to 9AM", "9:00 AM - 12:00 PM".
int _parseStartTimeMinutes(String timePart) {
  if (timePart.isEmpty) return 0;
  final match = RegExp(r'(\d+)(?::(\d+))?\s*(AM|PM)', caseSensitive: false)
      .firstMatch(timePart);
  if (match == null) return 0;
  int hour = int.tryParse(match.group(1)!) ?? 0;
  final min = int.tryParse(match.group(2) ?? '0') ?? 0;
  final ampm = match.group(3)!.toUpperCase();
  if (ampm == 'PM' && hour != 12) hour += 12;
  if (ampm == 'AM' && hour == 12) hour = 0;
  return hour * 60 + min;
}

/// Used by nearestSlot to compare slot dates against today.
DateTime? _parseSlotDate(String slot) => _parseSlotDateTime(slot);
