// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'woo_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WooOrder _$WooOrderFromJson(Map<String, dynamic> json) => _WooOrder(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      billing: WooBilling.fromJson(json['billing'] as Map<String, dynamic>),
      lineItems: (json['line_items'] as List<dynamic>)
          .map((e) => WooLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as String,
      currencySymbol: json['currency_symbol'] as String? ?? '₹',
    );

Map<String, dynamic> _$WooOrderToJson(_WooOrder instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'billing': instance.billing,
      'line_items': instance.lineItems,
      'total': instance.total,
      'currency_symbol': instance.currencySymbol,
    };

_WooBilling _$WooBillingFromJson(Map<String, dynamic> json) => _WooBilling(
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      address1: json['address_1'] as String? ?? '',
      address2: json['address_2'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postcode: json['postcode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );

Map<String, dynamic> _$WooBillingToJson(_WooBilling instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'address_1': instance.address1,
      'address_2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
      'country': instance.country,
      'email': instance.email,
      'phone': instance.phone,
    };

_WooLineItem _$WooLineItemFromJson(Map<String, dynamic> json) => _WooLineItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      total: json['total'] as String,
    );

Map<String, dynamic> _$WooLineItemToJson(_WooLineItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'total': instance.total,
    };
