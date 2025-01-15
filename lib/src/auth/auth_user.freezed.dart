// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return _AuthUser.fromJson(json);
}

/// @nodoc
mixin _$AuthUser {
  String? get id => throw _privateConstructorUsedError;
  String get uniqueId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  List<Badge>? get badges => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get configRef => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;
  bool? get emailVerified => throw _privateConstructorUsedError;
  bool? get emailServiceAgreement => throw _privateConstructorUsedError;
  dynamic get geohash => throw _privateConstructorUsedError;
  num get radius => throw _privateConstructorUsedError;
  num get longitude => throw _privateConstructorUsedError;
  num get latitude => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  bool? get isAnonymous => throw _privateConstructorUsedError;
  List<dynamic>? get providerData => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;
  List<Events>? get events => throw _privateConstructorUsedError;
  num? get reputation => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<Jobs>? get jobs => throw _privateConstructorUsedError;
  List<dynamic>? get orders => throw _privateConstructorUsedError;
  List<AppliedJobs>? get applications => throw _privateConstructorUsedError;
  List<GroupUser>? get groups => throw _privateConstructorUsedError;
  List<Follower>? get followers => throw _privateConstructorUsedError;
  List<Following>? get following => throw _privateConstructorUsedError;
  List<dynamic> get profession => throw _privateConstructorUsedError;
  List<dynamic> get education => throw _privateConstructorUsedError;
  List<dynamic> get interests => throw _privateConstructorUsedError;
  Player? get player => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get stripeId => throw _privateConstructorUsedError;
  List<dynamic>? get playerId => throw _privateConstructorUsedError;
  TeamAdmin? get coach => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  Address? get shipping => throw _privateConstructorUsedError;

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res, AuthUser>;
  @useResult
  $Res call(
      {String? id,
      String uniqueId,
      String? userId,
      String? email,
      List<Badge>? badges,
      String? firstName,
      String? lastName,
      String? photoURL,
      String city,
      String? displayName,
      String? configRef,
      String state,
      String country,
      String countryCode,
      String postalCode,
      bool? emailVerified,
      bool? emailServiceAgreement,
      dynamic geohash,
      num radius,
      num longitude,
      num latitude,
      String? phoneNumber,
      bool? isAnonymous,
      List<dynamic>? providerData,
      List<String> roles,
      String? refreshToken,
      dynamic createdAt,
      int timestamp,
      dynamic updatedAt,
      List<Events>? events,
      num? reputation,
      String status,
      List<Jobs>? jobs,
      List<dynamic>? orders,
      List<AppliedJobs>? applications,
      List<GroupUser>? groups,
      List<Follower>? followers,
      List<Following>? following,
      List<dynamic> profession,
      List<dynamic> education,
      List<dynamic> interests,
      Player? player,
      String? phone,
      String? stripeId,
      List<dynamic>? playerId,
      TeamAdmin? coach,
      String? website,
      Address? shipping});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res, $Val extends AuthUser>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uniqueId = null,
    Object? userId = freezed,
    Object? email = freezed,
    Object? badges = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? photoURL = freezed,
    Object? city = null,
    Object? displayName = freezed,
    Object? configRef = freezed,
    Object? state = null,
    Object? country = null,
    Object? countryCode = null,
    Object? postalCode = null,
    Object? emailVerified = freezed,
    Object? emailServiceAgreement = freezed,
    Object? geohash = freezed,
    Object? radius = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? phoneNumber = freezed,
    Object? isAnonymous = freezed,
    Object? providerData = freezed,
    Object? roles = null,
    Object? refreshToken = freezed,
    Object? createdAt = freezed,
    Object? timestamp = null,
    Object? updatedAt = freezed,
    Object? events = freezed,
    Object? reputation = freezed,
    Object? status = null,
    Object? jobs = freezed,
    Object? orders = freezed,
    Object? applications = freezed,
    Object? groups = freezed,
    Object? followers = freezed,
    Object? following = freezed,
    Object? profession = null,
    Object? education = null,
    Object? interests = null,
    Object? player = freezed,
    Object? phone = freezed,
    Object? stripeId = freezed,
    Object? playerId = freezed,
    Object? coach = freezed,
    Object? website = freezed,
    Object? shipping = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uniqueId: null == uniqueId
          ? _value.uniqueId
          : uniqueId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      badges: freezed == badges
          ? _value.badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<Badge>?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      configRef: freezed == configRef
          ? _value.configRef
          : configRef // ignore: cast_nullable_to_non_nullable
              as String?,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailServiceAgreement: freezed == emailServiceAgreement
          ? _value.emailServiceAgreement
          : emailServiceAgreement // ignore: cast_nullable_to_non_nullable
              as bool?,
      geohash: freezed == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as dynamic,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as num,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as num,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as num,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: freezed == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool?,
      providerData: freezed == providerData
          ? _value.providerData
          : providerData // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      events: freezed == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Events>?,
      reputation: freezed == reputation
          ? _value.reputation
          : reputation // ignore: cast_nullable_to_non_nullable
              as num?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      jobs: freezed == jobs
          ? _value.jobs
          : jobs // ignore: cast_nullable_to_non_nullable
              as List<Jobs>?,
      orders: freezed == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      applications: freezed == applications
          ? _value.applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<AppliedJobs>?,
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupUser>?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<Follower>?,
      following: freezed == following
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as List<Following>?,
      profession: null == profession
          ? _value.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      education: null == education
          ? _value.education
          : education // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeId: freezed == stripeId
          ? _value.stripeId
          : stripeId // ignore: cast_nullable_to_non_nullable
              as String?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      coach: freezed == coach
          ? _value.coach
          : coach // ignore: cast_nullable_to_non_nullable
              as TeamAdmin?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      shipping: freezed == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as Address?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthUserImplCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$$AuthUserImplCopyWith(
          _$AuthUserImpl value, $Res Function(_$AuthUserImpl) then) =
      __$$AuthUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String uniqueId,
      String? userId,
      String? email,
      List<Badge>? badges,
      String? firstName,
      String? lastName,
      String? photoURL,
      String city,
      String? displayName,
      String? configRef,
      String state,
      String country,
      String countryCode,
      String postalCode,
      bool? emailVerified,
      bool? emailServiceAgreement,
      dynamic geohash,
      num radius,
      num longitude,
      num latitude,
      String? phoneNumber,
      bool? isAnonymous,
      List<dynamic>? providerData,
      List<String> roles,
      String? refreshToken,
      dynamic createdAt,
      int timestamp,
      dynamic updatedAt,
      List<Events>? events,
      num? reputation,
      String status,
      List<Jobs>? jobs,
      List<dynamic>? orders,
      List<AppliedJobs>? applications,
      List<GroupUser>? groups,
      List<Follower>? followers,
      List<Following>? following,
      List<dynamic> profession,
      List<dynamic> education,
      List<dynamic> interests,
      Player? player,
      String? phone,
      String? stripeId,
      List<dynamic>? playerId,
      TeamAdmin? coach,
      String? website,
      Address? shipping});
}

/// @nodoc
class __$$AuthUserImplCopyWithImpl<$Res>
    extends _$AuthUserCopyWithImpl<$Res, _$AuthUserImpl>
    implements _$$AuthUserImplCopyWith<$Res> {
  __$$AuthUserImplCopyWithImpl(
      _$AuthUserImpl _value, $Res Function(_$AuthUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uniqueId = null,
    Object? userId = freezed,
    Object? email = freezed,
    Object? badges = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? photoURL = freezed,
    Object? city = null,
    Object? displayName = freezed,
    Object? configRef = freezed,
    Object? state = null,
    Object? country = null,
    Object? countryCode = null,
    Object? postalCode = null,
    Object? emailVerified = freezed,
    Object? emailServiceAgreement = freezed,
    Object? geohash = freezed,
    Object? radius = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? phoneNumber = freezed,
    Object? isAnonymous = freezed,
    Object? providerData = freezed,
    Object? roles = null,
    Object? refreshToken = freezed,
    Object? createdAt = freezed,
    Object? timestamp = null,
    Object? updatedAt = freezed,
    Object? events = freezed,
    Object? reputation = freezed,
    Object? status = null,
    Object? jobs = freezed,
    Object? orders = freezed,
    Object? applications = freezed,
    Object? groups = freezed,
    Object? followers = freezed,
    Object? following = freezed,
    Object? profession = null,
    Object? education = null,
    Object? interests = null,
    Object? player = freezed,
    Object? phone = freezed,
    Object? stripeId = freezed,
    Object? playerId = freezed,
    Object? coach = freezed,
    Object? website = freezed,
    Object? shipping = freezed,
  }) {
    return _then(_$AuthUserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uniqueId: null == uniqueId
          ? _value.uniqueId
          : uniqueId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      badges: freezed == badges
          ? _value._badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<Badge>?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      configRef: freezed == configRef
          ? _value.configRef
          : configRef // ignore: cast_nullable_to_non_nullable
              as String?,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailServiceAgreement: freezed == emailServiceAgreement
          ? _value.emailServiceAgreement
          : emailServiceAgreement // ignore: cast_nullable_to_non_nullable
              as bool?,
      geohash: freezed == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as dynamic,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as num,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as num,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as num,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: freezed == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool?,
      providerData: freezed == providerData
          ? _value._providerData
          : providerData // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      events: freezed == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Events>?,
      reputation: freezed == reputation
          ? _value.reputation
          : reputation // ignore: cast_nullable_to_non_nullable
              as num?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      jobs: freezed == jobs
          ? _value._jobs
          : jobs // ignore: cast_nullable_to_non_nullable
              as List<Jobs>?,
      orders: freezed == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      applications: freezed == applications
          ? _value._applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<AppliedJobs>?,
      groups: freezed == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupUser>?,
      followers: freezed == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<Follower>?,
      following: freezed == following
          ? _value._following
          : following // ignore: cast_nullable_to_non_nullable
              as List<Following>?,
      profession: null == profession
          ? _value._profession
          : profession // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      education: null == education
          ? _value._education
          : education // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      player: freezed == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeId: freezed == stripeId
          ? _value.stripeId
          : stripeId // ignore: cast_nullable_to_non_nullable
              as String?,
      playerId: freezed == playerId
          ? _value._playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      coach: freezed == coach
          ? _value.coach
          : coach // ignore: cast_nullable_to_non_nullable
              as TeamAdmin?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      shipping: freezed == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as Address?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserImpl implements _AuthUser {
  _$AuthUserImpl(
      {this.id,
      required this.uniqueId,
      this.userId,
      this.email,
      final List<Badge>? badges,
      this.firstName,
      this.lastName,
      this.photoURL,
      required this.city,
      this.displayName,
      this.configRef,
      required this.state,
      required this.country,
      required this.countryCode,
      required this.postalCode,
      this.emailVerified,
      this.emailServiceAgreement,
      required this.geohash,
      required this.radius,
      required this.longitude,
      required this.latitude,
      this.phoneNumber,
      this.isAnonymous,
      final List<dynamic>? providerData,
      required final List<String> roles,
      this.refreshToken,
      required this.createdAt,
      required this.timestamp,
      required this.updatedAt,
      final List<Events>? events,
      this.reputation,
      required this.status,
      final List<Jobs>? jobs,
      final List<dynamic>? orders,
      final List<AppliedJobs>? applications,
      final List<GroupUser>? groups,
      final List<Follower>? followers,
      final List<Following>? following,
      required final List<dynamic> profession,
      required final List<dynamic> education,
      required final List<dynamic> interests,
      this.player,
      this.phone,
      this.stripeId,
      final List<dynamic>? playerId,
      this.coach,
      this.website,
      this.shipping})
      : _badges = badges,
        _providerData = providerData,
        _roles = roles,
        _events = events,
        _jobs = jobs,
        _orders = orders,
        _applications = applications,
        _groups = groups,
        _followers = followers,
        _following = following,
        _profession = profession,
        _education = education,
        _interests = interests,
        _playerId = playerId;

  factory _$AuthUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserImplFromJson(json);

  @override
  final String? id;
  @override
  final String uniqueId;
  @override
  final String? userId;
  @override
  final String? email;
  final List<Badge>? _badges;
  @override
  List<Badge>? get badges {
    final value = _badges;
    if (value == null) return null;
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? photoURL;
  @override
  final String city;
  @override
  final String? displayName;
  @override
  final String? configRef;
  @override
  final String state;
  @override
  final String country;
  @override
  final String countryCode;
  @override
  final String postalCode;
  @override
  final bool? emailVerified;
  @override
  final bool? emailServiceAgreement;
  @override
  final dynamic geohash;
  @override
  final num radius;
  @override
  final num longitude;
  @override
  final num latitude;
  @override
  final String? phoneNumber;
  @override
  final bool? isAnonymous;
  final List<dynamic>? _providerData;
  @override
  List<dynamic>? get providerData {
    final value = _providerData;
    if (value == null) return null;
    if (_providerData is EqualUnmodifiableListView) return _providerData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final String? refreshToken;
  @override
  final dynamic createdAt;
  @override
  final int timestamp;
  @override
  final dynamic updatedAt;
  final List<Events>? _events;
  @override
  List<Events>? get events {
    final value = _events;
    if (value == null) return null;
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? reputation;
  @override
  final String status;
  final List<Jobs>? _jobs;
  @override
  List<Jobs>? get jobs {
    final value = _jobs;
    if (value == null) return null;
    if (_jobs is EqualUnmodifiableListView) return _jobs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _orders;
  @override
  List<dynamic>? get orders {
    final value = _orders;
    if (value == null) return null;
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AppliedJobs>? _applications;
  @override
  List<AppliedJobs>? get applications {
    final value = _applications;
    if (value == null) return null;
    if (_applications is EqualUnmodifiableListView) return _applications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<GroupUser>? _groups;
  @override
  List<GroupUser>? get groups {
    final value = _groups;
    if (value == null) return null;
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Follower>? _followers;
  @override
  List<Follower>? get followers {
    final value = _followers;
    if (value == null) return null;
    if (_followers is EqualUnmodifiableListView) return _followers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Following>? _following;
  @override
  List<Following>? get following {
    final value = _following;
    if (value == null) return null;
    if (_following is EqualUnmodifiableListView) return _following;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic> _profession;
  @override
  List<dynamic> get profession {
    if (_profession is EqualUnmodifiableListView) return _profession;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_profession);
  }

  final List<dynamic> _education;
  @override
  List<dynamic> get education {
    if (_education is EqualUnmodifiableListView) return _education;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_education);
  }

  final List<dynamic> _interests;
  @override
  List<dynamic> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  final Player? player;
  @override
  final String? phone;
  @override
  final String? stripeId;
  final List<dynamic>? _playerId;
  @override
  List<dynamic>? get playerId {
    final value = _playerId;
    if (value == null) return null;
    if (_playerId is EqualUnmodifiableListView) return _playerId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final TeamAdmin? coach;
  @override
  final String? website;
  @override
  final Address? shipping;

  @override
  String toString() {
    return 'AuthUser(id: $id, uniqueId: $uniqueId, userId: $userId, email: $email, badges: $badges, firstName: $firstName, lastName: $lastName, photoURL: $photoURL, city: $city, displayName: $displayName, configRef: $configRef, state: $state, country: $country, countryCode: $countryCode, postalCode: $postalCode, emailVerified: $emailVerified, emailServiceAgreement: $emailServiceAgreement, geohash: $geohash, radius: $radius, longitude: $longitude, latitude: $latitude, phoneNumber: $phoneNumber, isAnonymous: $isAnonymous, providerData: $providerData, roles: $roles, refreshToken: $refreshToken, createdAt: $createdAt, timestamp: $timestamp, updatedAt: $updatedAt, events: $events, reputation: $reputation, status: $status, jobs: $jobs, orders: $orders, applications: $applications, groups: $groups, followers: $followers, following: $following, profession: $profession, education: $education, interests: $interests, player: $player, phone: $phone, stripeId: $stripeId, playerId: $playerId, coach: $coach, website: $website, shipping: $shipping)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uniqueId, uniqueId) ||
                other.uniqueId == uniqueId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(other._badges, _badges) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.configRef, configRef) ||
                other.configRef == configRef) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.emailServiceAgreement, emailServiceAgreement) ||
                other.emailServiceAgreement == emailServiceAgreement) &&
            const DeepCollectionEquality().equals(other.geohash, geohash) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            const DeepCollectionEquality()
                .equals(other._providerData, _providerData) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.reputation, reputation) ||
                other.reputation == reputation) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._jobs, _jobs) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            const DeepCollectionEquality()
                .equals(other._applications, _applications) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality()
                .equals(other._following, _following) &&
            const DeepCollectionEquality()
                .equals(other._profession, _profession) &&
            const DeepCollectionEquality()
                .equals(other._education, _education) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.stripeId, stripeId) ||
                other.stripeId == stripeId) &&
            const DeepCollectionEquality().equals(other._playerId, _playerId) &&
            (identical(other.coach, coach) || other.coach == coach) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        uniqueId,
        userId,
        email,
        const DeepCollectionEquality().hash(_badges),
        firstName,
        lastName,
        photoURL,
        city,
        displayName,
        configRef,
        state,
        country,
        countryCode,
        postalCode,
        emailVerified,
        emailServiceAgreement,
        const DeepCollectionEquality().hash(geohash),
        radius,
        longitude,
        latitude,
        phoneNumber,
        isAnonymous,
        const DeepCollectionEquality().hash(_providerData),
        const DeepCollectionEquality().hash(_roles),
        refreshToken,
        const DeepCollectionEquality().hash(createdAt),
        timestamp,
        const DeepCollectionEquality().hash(updatedAt),
        const DeepCollectionEquality().hash(_events),
        reputation,
        status,
        const DeepCollectionEquality().hash(_jobs),
        const DeepCollectionEquality().hash(_orders),
        const DeepCollectionEquality().hash(_applications),
        const DeepCollectionEquality().hash(_groups),
        const DeepCollectionEquality().hash(_followers),
        const DeepCollectionEquality().hash(_following),
        const DeepCollectionEquality().hash(_profession),
        const DeepCollectionEquality().hash(_education),
        const DeepCollectionEquality().hash(_interests),
        player,
        phone,
        stripeId,
        const DeepCollectionEquality().hash(_playerId),
        coach,
        website,
        shipping
      ]);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      __$$AuthUserImplCopyWithImpl<_$AuthUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserImplToJson(
      this,
    );
  }
}

abstract class _AuthUser implements AuthUser {
  factory _AuthUser(
      {final String? id,
      required final String uniqueId,
      final String? userId,
      final String? email,
      final List<Badge>? badges,
      final String? firstName,
      final String? lastName,
      final String? photoURL,
      required final String city,
      final String? displayName,
      final String? configRef,
      required final String state,
      required final String country,
      required final String countryCode,
      required final String postalCode,
      final bool? emailVerified,
      final bool? emailServiceAgreement,
      required final dynamic geohash,
      required final num radius,
      required final num longitude,
      required final num latitude,
      final String? phoneNumber,
      final bool? isAnonymous,
      final List<dynamic>? providerData,
      required final List<String> roles,
      final String? refreshToken,
      required final dynamic createdAt,
      required final int timestamp,
      required final dynamic updatedAt,
      final List<Events>? events,
      final num? reputation,
      required final String status,
      final List<Jobs>? jobs,
      final List<dynamic>? orders,
      final List<AppliedJobs>? applications,
      final List<GroupUser>? groups,
      final List<Follower>? followers,
      final List<Following>? following,
      required final List<dynamic> profession,
      required final List<dynamic> education,
      required final List<dynamic> interests,
      final Player? player,
      final String? phone,
      final String? stripeId,
      final List<dynamic>? playerId,
      final TeamAdmin? coach,
      final String? website,
      final Address? shipping}) = _$AuthUserImpl;

  factory _AuthUser.fromJson(Map<String, dynamic> json) =
      _$AuthUserImpl.fromJson;

  @override
  String? get id;
  @override
  String get uniqueId;
  @override
  String? get userId;
  @override
  String? get email;
  @override
  List<Badge>? get badges;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get photoURL;
  @override
  String get city;
  @override
  String? get displayName;
  @override
  String? get configRef;
  @override
  String get state;
  @override
  String get country;
  @override
  String get countryCode;
  @override
  String get postalCode;
  @override
  bool? get emailVerified;
  @override
  bool? get emailServiceAgreement;
  @override
  dynamic get geohash;
  @override
  num get radius;
  @override
  num get longitude;
  @override
  num get latitude;
  @override
  String? get phoneNumber;
  @override
  bool? get isAnonymous;
  @override
  List<dynamic>? get providerData;
  @override
  List<String> get roles;
  @override
  String? get refreshToken;
  @override
  dynamic get createdAt;
  @override
  int get timestamp;
  @override
  dynamic get updatedAt;
  @override
  List<Events>? get events;
  @override
  num? get reputation;
  @override
  String get status;
  @override
  List<Jobs>? get jobs;
  @override
  List<dynamic>? get orders;
  @override
  List<AppliedJobs>? get applications;
  @override
  List<GroupUser>? get groups;
  @override
  List<Follower>? get followers;
  @override
  List<Following>? get following;
  @override
  List<dynamic> get profession;
  @override
  List<dynamic> get education;
  @override
  List<dynamic> get interests;
  @override
  Player? get player;
  @override
  String? get phone;
  @override
  String? get stripeId;
  @override
  List<dynamic>? get playerId;
  @override
  TeamAdmin? get coach;
  @override
  String? get website;
  @override
  Address? get shipping;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Badge _$BadgeFromJson(Map<String, dynamic> json) {
  return _Badge.fromJson(json);
}

/// @nodoc
mixin _$Badge {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Badge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeCopyWith<Badge> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeCopyWith<$Res> {
  factory $BadgeCopyWith(Badge value, $Res Function(Badge) then) =
      _$BadgeCopyWithImpl<$Res, Badge>;
  @useResult
  $Res call({String name, String description, String icon, int? createdAt});
}

/// @nodoc
class _$BadgeCopyWithImpl<$Res, $Val extends Badge>
    implements $BadgeCopyWith<$Res> {
  _$BadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeImplCopyWith<$Res> implements $BadgeCopyWith<$Res> {
  factory _$$BadgeImplCopyWith(
          _$BadgeImpl value, $Res Function(_$BadgeImpl) then) =
      __$$BadgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String description, String icon, int? createdAt});
}

/// @nodoc
class __$$BadgeImplCopyWithImpl<$Res>
    extends _$BadgeCopyWithImpl<$Res, _$BadgeImpl>
    implements _$$BadgeImplCopyWith<$Res> {
  __$$BadgeImplCopyWithImpl(
      _$BadgeImpl _value, $Res Function(_$BadgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$BadgeImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeImpl implements _Badge {
  const _$BadgeImpl(
      {required this.name,
      required this.description,
      required this.icon,
      this.createdAt});

  factory _$BadgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final String icon;
  @override
  final int? createdAt;

  @override
  String toString() {
    return 'Badge(name: $name, description: $description, icon: $icon, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, description, icon, createdAt);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      __$$BadgeImplCopyWithImpl<_$BadgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeImplToJson(
      this,
    );
  }
}

abstract class _Badge implements Badge {
  const factory _Badge(
      {required final String name,
      required final String description,
      required final String icon,
      final int? createdAt}) = _$BadgeImpl;

  factory _Badge.fromJson(Map<String, dynamic> json) = _$BadgeImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  String get icon;
  @override
  int? get createdAt;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  String? get filterLayout => throw _privateConstructorUsedError;
  List<dynamic> get notifications => throw _privateConstructorUsedError;
  Map<String, String>? get privacy => throw _privateConstructorUsedError;
  Map<String, String>? get preferences => throw _privateConstructorUsedError;
  Map<String, List<dynamic>>? get contentDiscovery =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get communication => throw _privateConstructorUsedError;
  Map<String, dynamic>? get personalization =>
      throw _privateConstructorUsedError;
  List<dynamic>? get settings => throw _privateConstructorUsedError;
  Map<String, bool> get onboarding => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {String? filterLayout,
      List<dynamic> notifications,
      Map<String, String>? privacy,
      Map<String, String>? preferences,
      Map<String, List<dynamic>>? contentDiscovery,
      Map<String, dynamic>? communication,
      Map<String, dynamic>? personalization,
      List<dynamic>? settings,
      Map<String, bool> onboarding});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterLayout = freezed,
    Object? notifications = null,
    Object? privacy = freezed,
    Object? preferences = freezed,
    Object? contentDiscovery = freezed,
    Object? communication = freezed,
    Object? personalization = freezed,
    Object? settings = freezed,
    Object? onboarding = null,
  }) {
    return _then(_value.copyWith(
      filterLayout: freezed == filterLayout
          ? _value.filterLayout
          : filterLayout // ignore: cast_nullable_to_non_nullable
              as String?,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      privacy: freezed == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      contentDiscovery: freezed == contentDiscovery
          ? _value.contentDiscovery
          : contentDiscovery // ignore: cast_nullable_to_non_nullable
              as Map<String, List<dynamic>>?,
      communication: freezed == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      personalization: freezed == personalization
          ? _value.personalization
          : personalization // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      onboarding: null == onboarding
          ? _value.onboarding
          : onboarding // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? filterLayout,
      List<dynamic> notifications,
      Map<String, String>? privacy,
      Map<String, String>? preferences,
      Map<String, List<dynamic>>? contentDiscovery,
      Map<String, dynamic>? communication,
      Map<String, dynamic>? personalization,
      List<dynamic>? settings,
      Map<String, bool> onboarding});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterLayout = freezed,
    Object? notifications = null,
    Object? privacy = freezed,
    Object? preferences = freezed,
    Object? contentDiscovery = freezed,
    Object? communication = freezed,
    Object? personalization = freezed,
    Object? settings = freezed,
    Object? onboarding = null,
  }) {
    return _then(_$UserSettingsImpl(
      filterLayout: freezed == filterLayout
          ? _value.filterLayout
          : filterLayout // ignore: cast_nullable_to_non_nullable
              as String?,
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      privacy: freezed == privacy
          ? _value._privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      contentDiscovery: freezed == contentDiscovery
          ? _value._contentDiscovery
          : contentDiscovery // ignore: cast_nullable_to_non_nullable
              as Map<String, List<dynamic>>?,
      communication: freezed == communication
          ? _value._communication
          : communication // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      personalization: freezed == personalization
          ? _value._personalization
          : personalization // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      onboarding: null == onboarding
          ? _value._onboarding
          : onboarding // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {this.filterLayout,
      final List<dynamic> notifications = const [],
      final Map<String, String>? privacy,
      final Map<String, String>? preferences,
      final Map<String, List<dynamic>>? contentDiscovery,
      final Map<String, dynamic>? communication,
      final Map<String, dynamic>? personalization,
      final List<dynamic>? settings,
      final Map<String, bool> onboarding = false})
      : _notifications = notifications,
        _privacy = privacy,
        _preferences = preferences,
        _contentDiscovery = contentDiscovery,
        _communication = communication,
        _personalization = personalization,
        _settings = settings,
        _onboarding = onboarding;

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  final String? filterLayout;
  final List<dynamic> _notifications;
  @override
  @JsonKey()
  List<dynamic> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  final Map<String, String>? _privacy;
  @override
  Map<String, String>? get privacy {
    final value = _privacy;
    if (value == null) return null;
    if (_privacy is EqualUnmodifiableMapView) return _privacy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _preferences;
  @override
  Map<String, String>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, List<dynamic>>? _contentDiscovery;
  @override
  Map<String, List<dynamic>>? get contentDiscovery {
    final value = _contentDiscovery;
    if (value == null) return null;
    if (_contentDiscovery is EqualUnmodifiableMapView) return _contentDiscovery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _communication;
  @override
  Map<String, dynamic>? get communication {
    final value = _communication;
    if (value == null) return null;
    if (_communication is EqualUnmodifiableMapView) return _communication;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _personalization;
  @override
  Map<String, dynamic>? get personalization {
    final value = _personalization;
    if (value == null) return null;
    if (_personalization is EqualUnmodifiableMapView) return _personalization;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<dynamic>? _settings;
  @override
  List<dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableListView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, bool> _onboarding;
  @override
  @JsonKey()
  Map<String, bool> get onboarding {
    if (_onboarding is EqualUnmodifiableMapView) return _onboarding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_onboarding);
  }

  @override
  String toString() {
    return 'UserSettings(filterLayout: $filterLayout, notifications: $notifications, privacy: $privacy, preferences: $preferences, contentDiscovery: $contentDiscovery, communication: $communication, personalization: $personalization, settings: $settings, onboarding: $onboarding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.filterLayout, filterLayout) ||
                other.filterLayout == filterLayout) &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            const DeepCollectionEquality().equals(other._privacy, _privacy) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            const DeepCollectionEquality()
                .equals(other._contentDiscovery, _contentDiscovery) &&
            const DeepCollectionEquality()
                .equals(other._communication, _communication) &&
            const DeepCollectionEquality()
                .equals(other._personalization, _personalization) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            const DeepCollectionEquality()
                .equals(other._onboarding, _onboarding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      filterLayout,
      const DeepCollectionEquality().hash(_notifications),
      const DeepCollectionEquality().hash(_privacy),
      const DeepCollectionEquality().hash(_preferences),
      const DeepCollectionEquality().hash(_contentDiscovery),
      const DeepCollectionEquality().hash(_communication),
      const DeepCollectionEquality().hash(_personalization),
      const DeepCollectionEquality().hash(_settings),
      const DeepCollectionEquality().hash(_onboarding));

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
      {final String? filterLayout,
      final List<dynamic> notifications,
      final Map<String, String>? privacy,
      final Map<String, String>? preferences,
      final Map<String, List<dynamic>>? contentDiscovery,
      final Map<String, dynamic>? communication,
      final Map<String, dynamic>? personalization,
      final List<dynamic>? settings,
      final Map<String, bool> onboarding}) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  String? get filterLayout;
  @override
  List<dynamic> get notifications;
  @override
  Map<String, String>? get privacy;
  @override
  Map<String, String>? get preferences;
  @override
  Map<String, List<dynamic>>? get contentDiscovery;
  @override
  Map<String, dynamic>? get communication;
  @override
  Map<String, dynamic>? get personalization;
  @override
  List<dynamic>? get settings;
  @override
  Map<String, bool> get onboarding;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
