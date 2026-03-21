// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'woo_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WooOrder {
  int get id;
  String get status;
  WooBilling get billing;
  @JsonKey(name: 'line_items')
  List<WooLineItem> get lineItems;
  String get total;
  @JsonKey(name: 'currency_symbol')
  String get currencySymbol;

  /// Create a copy of WooOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WooOrderCopyWith<WooOrder> get copyWith =>
      _$WooOrderCopyWithImpl<WooOrder>(this as WooOrder, _$identity);

  /// Serializes this WooOrder to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WooOrder &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.billing, billing) || other.billing == billing) &&
            const DeepCollectionEquality().equals(other.lineItems, lineItems) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, billing,
      const DeepCollectionEquality().hash(lineItems), total, currencySymbol);

  @override
  String toString() {
    return 'WooOrder(id: $id, status: $status, billing: $billing, lineItems: $lineItems, total: $total, currencySymbol: $currencySymbol)';
  }
}

/// @nodoc
abstract mixin class $WooOrderCopyWith<$Res> {
  factory $WooOrderCopyWith(WooOrder value, $Res Function(WooOrder) _then) =
      _$WooOrderCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String status,
      WooBilling billing,
      @JsonKey(name: 'line_items') List<WooLineItem> lineItems,
      String total,
      @JsonKey(name: 'currency_symbol') String currencySymbol});

  $WooBillingCopyWith<$Res> get billing;
}

/// @nodoc
class _$WooOrderCopyWithImpl<$Res> implements $WooOrderCopyWith<$Res> {
  _$WooOrderCopyWithImpl(this._self, this._then);

  final WooOrder _self;
  final $Res Function(WooOrder) _then;

  /// Create a copy of WooOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? billing = null,
    Object? lineItems = null,
    Object? total = null,
    Object? currencySymbol = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      billing: null == billing
          ? _self.billing
          : billing // ignore: cast_nullable_to_non_nullable
              as WooBilling,
      lineItems: null == lineItems
          ? _self.lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<WooLineItem>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _self.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of WooOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WooBillingCopyWith<$Res> get billing {
    return $WooBillingCopyWith<$Res>(_self.billing, (value) {
      return _then(_self.copyWith(billing: value));
    });
  }
}

/// Adds pattern-matching-related methods to [WooOrder].
extension WooOrderPatterns on WooOrder {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WooOrder value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WooOrder() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WooOrder value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooOrder():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WooOrder value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooOrder() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String status,
            WooBilling billing,
            @JsonKey(name: 'line_items') List<WooLineItem> lineItems,
            String total,
            @JsonKey(name: 'currency_symbol') String currencySymbol)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WooOrder() when $default != null:
        return $default(_that.id, _that.status, _that.billing, _that.lineItems,
            _that.total, _that.currencySymbol);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String status,
            WooBilling billing,
            @JsonKey(name: 'line_items') List<WooLineItem> lineItems,
            String total,
            @JsonKey(name: 'currency_symbol') String currencySymbol)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooOrder():
        return $default(_that.id, _that.status, _that.billing, _that.lineItems,
            _that.total, _that.currencySymbol);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String status,
            WooBilling billing,
            @JsonKey(name: 'line_items') List<WooLineItem> lineItems,
            String total,
            @JsonKey(name: 'currency_symbol') String currencySymbol)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooOrder() when $default != null:
        return $default(_that.id, _that.status, _that.billing, _that.lineItems,
            _that.total, _that.currencySymbol);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WooOrder implements WooOrder {
  const _WooOrder(
      {required this.id,
      required this.status,
      required this.billing,
      @JsonKey(name: 'line_items') required final List<WooLineItem> lineItems,
      required this.total,
      @JsonKey(name: 'currency_symbol') this.currencySymbol = '₹'})
      : _lineItems = lineItems;
  factory _WooOrder.fromJson(Map<String, dynamic> json) =>
      _$WooOrderFromJson(json);

  @override
  final int id;
  @override
  final String status;
  @override
  final WooBilling billing;
  final List<WooLineItem> _lineItems;
  @override
  @JsonKey(name: 'line_items')
  List<WooLineItem> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  final String total;
  @override
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;

  /// Create a copy of WooOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WooOrderCopyWith<_WooOrder> get copyWith =>
      __$WooOrderCopyWithImpl<_WooOrder>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WooOrderToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WooOrder &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.billing, billing) || other.billing == billing) &&
            const DeepCollectionEquality()
                .equals(other._lineItems, _lineItems) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, billing,
      const DeepCollectionEquality().hash(_lineItems), total, currencySymbol);

  @override
  String toString() {
    return 'WooOrder(id: $id, status: $status, billing: $billing, lineItems: $lineItems, total: $total, currencySymbol: $currencySymbol)';
  }
}

/// @nodoc
abstract mixin class _$WooOrderCopyWith<$Res>
    implements $WooOrderCopyWith<$Res> {
  factory _$WooOrderCopyWith(_WooOrder value, $Res Function(_WooOrder) _then) =
      __$WooOrderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String status,
      WooBilling billing,
      @JsonKey(name: 'line_items') List<WooLineItem> lineItems,
      String total,
      @JsonKey(name: 'currency_symbol') String currencySymbol});

  @override
  $WooBillingCopyWith<$Res> get billing;
}

/// @nodoc
class __$WooOrderCopyWithImpl<$Res> implements _$WooOrderCopyWith<$Res> {
  __$WooOrderCopyWithImpl(this._self, this._then);

  final _WooOrder _self;
  final $Res Function(_WooOrder) _then;

  /// Create a copy of WooOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? billing = null,
    Object? lineItems = null,
    Object? total = null,
    Object? currencySymbol = null,
  }) {
    return _then(_WooOrder(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      billing: null == billing
          ? _self.billing
          : billing // ignore: cast_nullable_to_non_nullable
              as WooBilling,
      lineItems: null == lineItems
          ? _self._lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<WooLineItem>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      currencySymbol: null == currencySymbol
          ? _self.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of WooOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WooBillingCopyWith<$Res> get billing {
    return $WooBillingCopyWith<$Res>(_self.billing, (value) {
      return _then(_self.copyWith(billing: value));
    });
  }
}

/// @nodoc
mixin _$WooBilling {
  @JsonKey(name: 'first_name')
  String get firstName;
  @JsonKey(name: 'last_name')
  String get lastName;
  @JsonKey(name: 'address_1')
  String get address1;
  @JsonKey(name: 'address_2')
  String get address2;
  String get city;
  String get state;
  String get postcode;
  String get country;
  String get email;
  String get phone;

  /// Create a copy of WooBilling
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WooBillingCopyWith<WooBilling> get copyWith =>
      _$WooBillingCopyWithImpl<WooBilling>(this as WooBilling, _$identity);

  /// Serializes this WooBilling to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WooBilling &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, address1,
      address2, city, state, postcode, country, email, phone);

  @override
  String toString() {
    return 'WooBilling(firstName: $firstName, lastName: $lastName, address1: $address1, address2: $address2, city: $city, state: $state, postcode: $postcode, country: $country, email: $email, phone: $phone)';
  }
}

/// @nodoc
abstract mixin class $WooBillingCopyWith<$Res> {
  factory $WooBillingCopyWith(
          WooBilling value, $Res Function(WooBilling) _then) =
      _$WooBillingCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'address_1') String address1,
      @JsonKey(name: 'address_2') String address2,
      String city,
      String state,
      String postcode,
      String country,
      String email,
      String phone});
}

/// @nodoc
class _$WooBillingCopyWithImpl<$Res> implements $WooBillingCopyWith<$Res> {
  _$WooBillingCopyWithImpl(this._self, this._then);

  final WooBilling _self;
  final $Res Function(WooBilling) _then;

  /// Create a copy of WooBilling
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? address1 = null,
    Object? address2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
    Object? country = null,
    Object? email = null,
    Object? phone = null,
  }) {
    return _then(_self.copyWith(
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      address1: null == address1
          ? _self.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String,
      address2: null == address2
          ? _self.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postcode: null == postcode
          ? _self.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [WooBilling].
extension WooBillingPatterns on WooBilling {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WooBilling value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WooBilling() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WooBilling value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooBilling():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WooBilling value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooBilling() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'first_name') String firstName,
            @JsonKey(name: 'last_name') String lastName,
            @JsonKey(name: 'address_1') String address1,
            @JsonKey(name: 'address_2') String address2,
            String city,
            String state,
            String postcode,
            String country,
            String email,
            String phone)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WooBilling() when $default != null:
        return $default(
            _that.firstName,
            _that.lastName,
            _that.address1,
            _that.address2,
            _that.city,
            _that.state,
            _that.postcode,
            _that.country,
            _that.email,
            _that.phone);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'first_name') String firstName,
            @JsonKey(name: 'last_name') String lastName,
            @JsonKey(name: 'address_1') String address1,
            @JsonKey(name: 'address_2') String address2,
            String city,
            String state,
            String postcode,
            String country,
            String email,
            String phone)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooBilling():
        return $default(
            _that.firstName,
            _that.lastName,
            _that.address1,
            _that.address2,
            _that.city,
            _that.state,
            _that.postcode,
            _that.country,
            _that.email,
            _that.phone);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'first_name') String firstName,
            @JsonKey(name: 'last_name') String lastName,
            @JsonKey(name: 'address_1') String address1,
            @JsonKey(name: 'address_2') String address2,
            String city,
            String state,
            String postcode,
            String country,
            String email,
            String phone)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooBilling() when $default != null:
        return $default(
            _that.firstName,
            _that.lastName,
            _that.address1,
            _that.address2,
            _that.city,
            _that.state,
            _that.postcode,
            _that.country,
            _that.email,
            _that.phone);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WooBilling implements WooBilling {
  const _WooBilling(
      {@JsonKey(name: 'first_name') this.firstName = '',
      @JsonKey(name: 'last_name') this.lastName = '',
      @JsonKey(name: 'address_1') this.address1 = '',
      @JsonKey(name: 'address_2') this.address2 = '',
      this.city = '',
      this.state = '',
      this.postcode = '',
      this.country = '',
      this.email = '',
      this.phone = ''});
  factory _WooBilling.fromJson(Map<String, dynamic> json) =>
      _$WooBillingFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'address_1')
  final String address1;
  @override
  @JsonKey(name: 'address_2')
  final String address2;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String postcode;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phone;

  /// Create a copy of WooBilling
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WooBillingCopyWith<_WooBilling> get copyWith =>
      __$WooBillingCopyWithImpl<_WooBilling>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WooBillingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WooBilling &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, address1,
      address2, city, state, postcode, country, email, phone);

  @override
  String toString() {
    return 'WooBilling(firstName: $firstName, lastName: $lastName, address1: $address1, address2: $address2, city: $city, state: $state, postcode: $postcode, country: $country, email: $email, phone: $phone)';
  }
}

/// @nodoc
abstract mixin class _$WooBillingCopyWith<$Res>
    implements $WooBillingCopyWith<$Res> {
  factory _$WooBillingCopyWith(
          _WooBilling value, $Res Function(_WooBilling) _then) =
      __$WooBillingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'address_1') String address1,
      @JsonKey(name: 'address_2') String address2,
      String city,
      String state,
      String postcode,
      String country,
      String email,
      String phone});
}

/// @nodoc
class __$WooBillingCopyWithImpl<$Res> implements _$WooBillingCopyWith<$Res> {
  __$WooBillingCopyWithImpl(this._self, this._then);

  final _WooBilling _self;
  final $Res Function(_WooBilling) _then;

  /// Create a copy of WooBilling
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? address1 = null,
    Object? address2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
    Object? country = null,
    Object? email = null,
    Object? phone = null,
  }) {
    return _then(_WooBilling(
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      address1: null == address1
          ? _self.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String,
      address2: null == address2
          ? _self.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postcode: null == postcode
          ? _self.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$WooLineItem {
  int get id;
  String get name;
  int get quantity;
  String get total;

  /// Create a copy of WooLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WooLineItemCopyWith<WooLineItem> get copyWith =>
      _$WooLineItemCopyWithImpl<WooLineItem>(this as WooLineItem, _$identity);

  /// Serializes this WooLineItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WooLineItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, total);

  @override
  String toString() {
    return 'WooLineItem(id: $id, name: $name, quantity: $quantity, total: $total)';
  }
}

/// @nodoc
abstract mixin class $WooLineItemCopyWith<$Res> {
  factory $WooLineItemCopyWith(
          WooLineItem value, $Res Function(WooLineItem) _then) =
      _$WooLineItemCopyWithImpl;
  @useResult
  $Res call({int id, String name, int quantity, String total});
}

/// @nodoc
class _$WooLineItemCopyWithImpl<$Res> implements $WooLineItemCopyWith<$Res> {
  _$WooLineItemCopyWithImpl(this._self, this._then);

  final WooLineItem _self;
  final $Res Function(WooLineItem) _then;

  /// Create a copy of WooLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? total = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [WooLineItem].
extension WooLineItemPatterns on WooLineItem {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WooLineItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WooLineItem() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WooLineItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooLineItem():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WooLineItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooLineItem() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name, int quantity, String total)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WooLineItem() when $default != null:
        return $default(_that.id, _that.name, _that.quantity, _that.total);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name, int quantity, String total) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooLineItem():
        return $default(_that.id, _that.name, _that.quantity, _that.total);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name, int quantity, String total)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WooLineItem() when $default != null:
        return $default(_that.id, _that.name, _that.quantity, _that.total);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WooLineItem implements WooLineItem {
  const _WooLineItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.total});
  factory _WooLineItem.fromJson(Map<String, dynamic> json) =>
      _$WooLineItemFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final String total;

  /// Create a copy of WooLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WooLineItemCopyWith<_WooLineItem> get copyWith =>
      __$WooLineItemCopyWithImpl<_WooLineItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WooLineItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WooLineItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, total);

  @override
  String toString() {
    return 'WooLineItem(id: $id, name: $name, quantity: $quantity, total: $total)';
  }
}

/// @nodoc
abstract mixin class _$WooLineItemCopyWith<$Res>
    implements $WooLineItemCopyWith<$Res> {
  factory _$WooLineItemCopyWith(
          _WooLineItem value, $Res Function(_WooLineItem) _then) =
      __$WooLineItemCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String name, int quantity, String total});
}

/// @nodoc
class __$WooLineItemCopyWithImpl<$Res> implements _$WooLineItemCopyWith<$Res> {
  __$WooLineItemCopyWithImpl(this._self, this._then);

  final _WooLineItem _self;
  final $Res Function(_WooLineItem) _then;

  /// Create a copy of WooLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? total = null,
  }) {
    return _then(_WooLineItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
