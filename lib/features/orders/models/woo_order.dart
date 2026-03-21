import 'package:freezed_annotation/freezed_annotation.dart';

part 'woo_order.freezed.dart';
part 'woo_order.g.dart';

@freezed
abstract class WooOrder with _$WooOrder {
  const factory WooOrder({
    required int id,
    required String status,
    required WooBilling billing,
    @JsonKey(name: 'line_items') required List<WooLineItem> lineItems,
    required String total,
    @JsonKey(name: 'currency_symbol') @Default('₹') String currencySymbol,
  }) = _WooOrder;

  factory WooOrder.fromJson(Map<String, dynamic> json) =>
      _$WooOrderFromJson(json);
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
