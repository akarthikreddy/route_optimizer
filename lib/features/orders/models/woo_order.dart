import 'package:freezed_annotation/freezed_annotation.dart';

part 'woo_order.freezed.dart';
part 'woo_order.g.dart';

Map<String, String> _metaDataFromJson(List<dynamic>? list) {
  if (list == null) return {};
  final result = <String, String>{};
  for (final item in list) {
    if (item is Map<String, dynamic>) {
      final key = item['key'] as String? ?? '';
      final val = item['value'];
      if (key.isNotEmpty) result[key] = val?.toString() ?? '';
    }
  }
  return result;
}

List<dynamic> _metaDataToJson(Map<String, String> _) => [];

@freezed
abstract class WooOrder with _$WooOrder {
  const factory WooOrder({
    required int id,
    required String status,
    required WooBilling billing,
    @JsonKey(name: 'line_items') required List<WooLineItem> lineItems,
    required String total,
    @JsonKey(name: 'currency_symbol') @Default('₹') String currencySymbol,
    @JsonKey(name: 'meta_data', fromJson: _metaDataFromJson, toJson: _metaDataToJson)
    @Default({}) Map<String, String> metaData,
  }) = _WooOrder;

  factory WooOrder.fromJson(Map<String, dynamic> json) =>
      _$WooOrderFromJson(json);
}

extension WooOrderX on WooOrder {
  String get deliveryDate => _norm(metaData['billing_delivery_date'] ?? '');
  String get deliveryTimeSlot =>
      _norm(metaData['billing_delivery_time_slot'] ?? '');

  /// Normalised key for grouping.
  /// Date is converted to YYYY-MM-DD so "27 March", "27-03-2026", "27/03/2026"
  /// all produce the same key. Time is lowercased for case-insensitive match.
  String get deliverySlot {
    final d = _parseDateToIso(deliveryDate) ?? deliveryDate.toLowerCase().replaceAll('/', '-');
    final t = deliveryTimeSlot.toLowerCase();
    if (d.isEmpty && t.isEmpty) return '';
    if (d.isEmpty) return t;
    if (t.isEmpty) return d;
    return '$d|$t';
  }

  /// Human-readable label: "27-MAR | 6AM to 9AM"
  String get deliverySlotDisplay {
    final d = _formatDate(deliveryDate);
    final t = _capitaliseAmPm(deliveryTimeSlot);
    if (d.isEmpty && t.isEmpty) return '';
    if (d.isEmpty) return t;
    if (t.isEmpty) return d;
    return '$d | $t';
  }
}

const _monthAbbr = [
  '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

/// Trims and collapses internal whitespace so "6Am  to 9Am" == "6Am to 9Am".
String _norm(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');

const _monthIndex = {
  'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
  'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  'january': 1, 'february': 2, 'march': 3, 'april': 4, 'june': 6,
  'july': 7, 'august': 8, 'september': 9, 'october': 10,
  'november': 11, 'december': 12,
};

/// Converts any recognisable date format to "YYYY-MM-DD" for key normalisation.
/// Handles: DD-MM-YYYY, DD/MM/YYYY, YYYY-MM-DD, "27 March", "27 March 2026",
///          "March 27", "March 27, 2026".
String? _parseDateToIso(String raw) {
  if (raw.isEmpty) return null;
  final s = raw.trim().toLowerCase();

  // Split on / or - to get parts (works for numeric and mixed formats)
  final numParts = s.split(RegExp(r'[/\-]'));

  if (numParts.length >= 2) {
    // DD-MonthName-YYYY or DD-MonthName (e.g. "27-Mar-2026", "27-mar")
    final possibleDay = int.tryParse(numParts[0]);
    final possibleMonth = _monthIndex[numParts[1]];
    if (possibleDay != null && possibleMonth != null) {
      final year = numParts.length >= 3
          ? (int.tryParse(numParts[2]) ?? DateTime.now().year)
          : DateTime.now().year;
      return '$year-${possibleMonth.toString().padLeft(2, '0')}-${possibleDay.toString().padLeft(2, '0')}';
    }
  }

  if (numParts.length == 3) {
    final a = int.tryParse(numParts[0]);
    final b = int.tryParse(numParts[1]);
    final c = int.tryParse(numParts[2]);
    if (a != null && b != null && c != null) {
      int day, month, year;
      if (c > 31) { day = a; month = b; year = c; }      // DD-MM-YYYY
      else if (a > 31) { day = c; month = b; year = a; } // YYYY-MM-DD
      else return null;
      if (month < 1 || month > 12) return null;
      return '$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}';
    }
  }

  // Month-name formats: "27 march 2026", "march 27, 2026", "27 march", "march 27"
  final wordMatch = RegExp(
    r'^(\d{1,2})\s+([a-z]+)(?:[,\s]+(\d{4}))?$|^([a-z]+)\s+(\d{1,2})(?:[,\s]+(\d{4}))?$',
  ).firstMatch(s);
  if (wordMatch != null) {
    int? day, month, year;
    if (wordMatch.group(1) != null) {
      day = int.tryParse(wordMatch.group(1)!);
      month = _monthIndex[wordMatch.group(2)];
      year = int.tryParse(wordMatch.group(3) ?? '');
    } else {
      month = _monthIndex[wordMatch.group(4)];
      day = int.tryParse(wordMatch.group(5)!);
      year = int.tryParse(wordMatch.group(6) ?? '');
    }
    year ??= DateTime.now().year;
    if (day != null && month != null) {
      return '$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}';
    }
  }

  return null;
}

/// Uppercases AM/PM tokens: "6Am to 9Am" → "6AM to 9AM"
String _capitaliseAmPm(String s) =>
    s.replaceAllMapped(RegExp(r'\b(am|pm)\b', caseSensitive: false),
        (m) => m.group(0)!.toUpperCase());

String _formatDate(String raw) {
  if (raw.isEmpty) return raw;
  final parts = raw.split(RegExp(r'[/\-]'));
  if (parts.length == 3) {
    final a = int.tryParse(parts[0]);
    final b = int.tryParse(parts[1]);
    final c = int.tryParse(parts[2]);
    if (a != null && b != null && c != null) {
      int day, month;
      if (c > 31) {
        // DD-MM-YYYY
        day = a; month = b;
      } else if (a > 31) {
        // YYYY-MM-DD
        day = c; month = b;
      } else {
        return raw;
      }
      if (month >= 1 && month <= 12) return '$day-${_monthAbbr[month]}';
    }
  }
  return raw;
}

@freezed
abstract class WooBilling with _$WooBilling {
  const factory WooBilling({
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @JsonKey(name: 'address_1') @Default('') String address1,
    @JsonKey(name: 'address_2') @Default('') String address2,
    @Default('') String city,
    @Default('') String state,
    @Default('') String postcode,
    @Default('') String country,
    @Default('') String email,
    @Default('') String phone,
  }) = _WooBilling;

  factory WooBilling.fromJson(Map<String, dynamic> json) =>
      _$WooBillingFromJson(json);
}

extension WooBillingX on WooBilling {
  String get fullName => '$firstName $lastName'.trim();

  String get fullAddress {
    final parts = [
      address1,
      if (address2.isNotEmpty) address2,
      city,
      if (state.isNotEmpty) state,
      postcode,
      if (country.isNotEmpty) country,
    ].where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }
}

@freezed
abstract class WooLineItem with _$WooLineItem {
  const factory WooLineItem({
    required int id,
    required String name,
    required int quantity,
    required String total,
  }) = _WooLineItem;

  factory WooLineItem.fromJson(Map<String, dynamic> json) =>
      _$WooLineItemFromJson(json);
}
