import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/woo_order.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredOrdersProvider);
    final slotsAsync = ref.watch(availableSlotsProvider);
    final selectedSlots = ref.watch(selectedSlotsProvider);

    void refresh() {
      ref.invalidate(ordersProvider);
      ref.read(slotInitialisedProvider.notifier).state = false;
      ref.read(selectedSlotsProvider.notifier).clearAll();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => context.go('/config'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // Slot filter bar
          slotsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (slots) => slots.isEmpty
                ? const SizedBox.shrink()
                : _SlotFilterBar(slots: slots, selected: selectedSlots),
          ),
          // Orders list
          Expanded(
            child: filteredAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorView(
                message: e.toString(),
                onRetry: refresh,
              ),
              data: (orders) => orders.isEmpty
                  ? _EmptyView(onRefresh: refresh)
                  : _OrdersList(orders: orders),
            ),
          ),
        ],
      ),
      floatingActionButton: filteredAsync.whenOrNull(
        data: (orders) => orders.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.go('/map'),
                backgroundColor: AppColors.brand,
                icon: const Icon(Icons.map, color: Colors.white),
                label: const Text(
                  'Optimize Routes',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
      ),
    );
  }
}

class _SlotFilterBar extends ConsumerWidget {
  const _SlotFilterBar({required this.slots, required this.selected});
  final List<String> slots;
  final Set<String> selected;

  String get _label {
    if (selected.isEmpty) return 'All slots';
    if (selected.length == 1) return _formatSlotLabel(selected.first);
    return '${selected.length} slots selected';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _showSlotPicker(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border:
              Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected.isEmpty
                          ? AppColors.textSecondary
                          : AppColors.brand,
                      fontWeight: selected.isEmpty
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
              ),
            ),
            const Icon(Icons.expand_more, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showSlotPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _SlotPickerSheet(slots: slots),
    );
  }
}

class _SlotPickerSheet extends ConsumerStatefulWidget {
  const _SlotPickerSheet({required this.slots});
  final List<String> slots;

  @override
  ConsumerState<_SlotPickerSheet> createState() => _SlotPickerSheetState();
}

class _SlotPickerSheetState extends ConsumerState<_SlotPickerSheet> {
  late Set<String> _local;

  @override
  void initState() {
    super.initState();
    final providerState = ref.read(selectedSlotsProvider);
    // Empty provider state means "all" — initialise local with all slots so
    // every checkbox starts checked and empty-set ambiguity is avoided.
    _local = providerState.isEmpty
        ? Set.from(widget.slots)
        : Set.from(providerState);
  }

  void _toggle(String slot) {
    // Prevent deselecting the last checked slot.
    if (_local.contains(slot) && _local.length == 1) return;
    setState(() {
      if (_local.contains(slot)) {
        _local.remove(slot);
      } else {
        _local.add(slot);
      }
    });
    // Sync to provider: if all slots are selected use empty (= show all).
    if (_local.length == widget.slots.length) {
      ref.read(selectedSlotsProvider.notifier).clearAll();
    } else {
      ref.read(selectedSlotsProvider.notifier).selectAll(_local.toList());
    }
  }

  void _selectAll() {
    setState(() => _local = Set.from(widget.slots));
    ref.read(selectedSlotsProvider.notifier).selectAll(widget.slots);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Delivery Slots',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              TextButton(
                onPressed: _selectAll,
                child: const Text('Select All',
                    style: TextStyle(color: AppColors.brand)),
              ),
            ],
          ),
          const Divider(height: 8),
          ...widget.slots.map((slot) {
            final isChecked = _local.contains(slot);
            return CheckboxListTile(
              key: ValueKey(slot),
              value: isChecked,
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.brand,
              title: Text(_formatSlotLabel(slot),
                  style: Theme.of(context).textTheme.bodyMedium),
              onChanged: (_) => _toggle(slot),
            );
          }),
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});
  final List<WooOrder> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            '${orders.length} order${orders.length != 1 ? 's' : ''} to deliver',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
            itemCount: orders.length,
            itemBuilder: (_, i) => _OrderCard(order: orders[i]),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final WooOrder order;

  @override
  Widget build(BuildContext context) {
    final billing = order.billing;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '#${order.id} — ${billing.fullName}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  '${order.currencySymbol}${order.total}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.brand,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    billing.fullAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (billing.phone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    billing.phone,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
            if (order.deliverySlotDisplay.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.schedule,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    order.deliverySlotDisplay,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: order.lineItems.map((item) {
                return Chip(
                  label: Text(
                    '${item.name} ×${item.quantity}',
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 72, color: AppColors.divider),
          const SizedBox(height: 16),
          Text('No processing orders',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Failed to load orders',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Formats a slot key for display: "2026-03-27|6am to 9am" → "27-MAR | 6AM to 9AM"
String _formatSlotLabel(String slot) {
  final parts = slot.split('|');
  final datePart = _formatDatePart(parts.first.trim());
  if (parts.length < 2) return datePart;
  final timePart = parts.sublist(1).join('|').trim()
      .replaceAllMapped(RegExp(r'\b(am|pm)\b', caseSensitive: false),
          (m) => m.group(0)!.toUpperCase());
  return '$datePart | $timePart';
}

const _monthAbbr = [
  '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

String _formatDatePart(String raw) {
  final parts = raw.split(RegExp(r'[/\-]'));
  if (parts.length == 3) {
    final a = int.tryParse(parts[0]);
    final b = int.tryParse(parts[1]);
    final c = int.tryParse(parts[2]);
    if (a != null && b != null && c != null) {
      int day, month;
      if (c > 31) { day = a; month = b; }        // DD-MM-YYYY
      else if (a > 31) { day = c; month = b; }    // YYYY-MM-DD
      else return raw;
      if (month >= 1 && month <= 12) return '$day-${_monthAbbr[month]}';
    }
  }
  return raw;
}
