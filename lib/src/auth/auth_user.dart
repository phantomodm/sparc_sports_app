// AuthUser model
import 'package:sparc_sports_app/src/sparc/models/filter_layout_model.dart';
import 'package:sparc_sports_app/src/sparc/models/league_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part "auth_user.g.dart";

@freezed
class AuthUser with _$AuthUser {
  factory AuthUser({
    String? id,
    required String uniqueId,
    String? userId,
    String? email,
    List<Badge>? badges,
    String? firstName,
    String? lastName,
    String? photoURL,
    required String city,
    String? displayName,
    String? configRef,
    required String state,
    required String country,
    required String countryCode,
    required String postalCode,
    bool? emailVerified,
    bool? emailServiceAgreement,
    required dynamic geohash,
    required num radius,
    required num longitude,
    required num latitude,
    String? phoneNumber,
    bool? isAnonymous,
    List<dynamic>? providerData,
    required List<String> roles,
    String? refreshToken,
    required dynamic createdAt,
    required int timestamp,
    required dynamic updatedAt,
    List<Events>? events,
    num? reputation,
    required String status,
    List<Jobs>? jobs,
    List<dynamic>? orders,
    List<AppliedJobs>? applications,
    List<GroupUser>? groups,
    List<Follower>? followers,
    List<Following>? following,
    required List<dynamic> profession,
    required List<dynamic> education,
    required List<dynamic> interests,
    Player? player,
    String? phone,
    String? stripeId,
    List<dynamic>? playerId,
    TeamAdmin? coach,
    String? website,
    Address? shipping,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}
/*class AuthUser {
  final String? id;
  final String uniqueId;
  final String? userId;
  final String? email;
  final List<Badge>? badges;
  final String? firstName;
  final String? lastName;
  final String? photoURL;
  final String city;
  final String? displayName;
  final String? configRef;
  final String state;
  final String country;
  final String countryCode;
  final String postalCode;
  final bool? emailVerified;
  final bool? emailServiceAgreement;
  final dynamic geohash;
  final num? radius;
  final num? longitude;
  final num? latitude;
  final String? phoneNumber;
  final bool? isAnonymous;
  final List<dynamic>? providerData;
  final List<String> roles;
  final String? refreshToken;
  final dynamic createdAt;
  final int? timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final dynamic? updatedAt;
  final List<Events>? events;
  final num? reputation;
  final String? status;
  final List<Jobs>? jobs;
  final List<dynamic>? orders;
  final List<AppliedJobs>? applications;
  final List<GroupUser>? groups;
  final List<Follower>? followers;
  final List<Following>? following;
  final List<dynamic> profession;
  final List<dynamic> education;
  final List<dynamic> interests;
  final Player? player;
  final String? phone;
  final String? stripeId;
  final List<dynamic>? playerId;
  final TeamAdmin? coach;
  final String? website;
  final Address? shipping;

  factory AuthUser({
    this.id,
    required this.uniqueId,
    this.userId,
    this.email,
    this.badges,
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
    this.providerData,
    required this.roles,
    this.refreshToken,
    required this.createdAt,
    required this.timestamp,
    required this.updatedAt,
    this.events,
    this.reputation,
    required this.status,
    this.jobs,
    this.orders,
    this.applications,
    this.groups,
    this.followers,
    this.following,
    required this.profession,
    required this.education,
    required this.interests,
    this.player,
    this.phone,
    this.stripeId,
    this.playerId,
    this.coach,
    this.website,
    this.shipping,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      uniqueId: json['uniqueId'],
      userId: json['userId'],
      email: json['email'],
      badges: (json['badges'] as List?)?.map((badgeJson) => Badge.fromJson(badgeJson)).toList(),
      firstName: json['firstName'],
      lastName: json['lastName'],
      photoURL: json['photoURL'],
      city: json['city'],
      displayName: json['displayName'],
      configRef: json['configRef'],
      state: json['state'],
      country: json['country'],
      countryCode: json['countryCode'],
      postalCode: json['postalCode'],
      emailVerified: json['emailVerified'],
      emailServiceAgreement: json['emailServiceAgreement'],
      geohash: json['geohash'],
      radius: json['radius'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      phoneNumber: json['phoneNumber'],
      isAnonymous: json['isAnonymous'],
      providerData: json['providerData'],
      roles: List<String>.from(json['roles']),
      refreshToken: json['refreshToken'],
      createdAt: json['createdAt'],
      timestamp: json['timestamp']['seconds'], // Assuming timestamp.seconds is the epoch time
      updatedAt: json['updatedAt'],
      events: (json['events'] as List?)?.map((eventJson) => Events.fromJson(eventJson)).toList(),
      reputation: json['reputation'],
      status: json['status'],
      jobs: (json['jobs'] as List?)?.map((jobJson) => Jobs.fromJson(jobJson)).toList(),
      orders: json['orders'],
      applications: (json['applications'] as List?)?.map((applicationJson) => AppliedJobs.fromJson(applicationJson)).toList(),
      groups: (json['groups'] as List?)?.map((groupJson) => GroupUser.fromJson(groupJson)).toList(),
      followers: (json['followers'] as List?)?.map((followerJson) => Follower.fromJson(followerJson)).toList(),
      following: (json['following'] as List?)?.map((followingJson) => Following.fromJson(followingJson)).toList(),
      profession: List<dynamic>.from(json['profession']),
      education: List<dynamic>.from(json['education']),
      interests: List<dynamic>.from(json['interests']),
      player: json['player'] != null ? Player.fromJson(json['player']) : null,
      phone: json['phone'],
      stripeId: json['stripe_id'],
      playerId: json['playerId'],
      coach: json['coach'] != null ? TeamAdmin.fromJson(json['coach']) : null,
      website: json['website'],
      shipping: json['shipping'] != null ? Address.fromJson(json['shipping']) : null,
    );
  }
  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
    };
  }
}*/

// Address model
class Address {
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String zip;

  Address({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      line1: json['line1'],
      line2: json['line2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      zip: json['zip'],
    );
  }
}

// Badge model
@freezed
class Badge with _$Badge{
  const factory Badge ({
     required String name,
    required String description,
    required String icon,
     int? createdAt,
  }) = _Badge;
  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

class UserRank {
  final String userId;
  final int rank;
  final int points;

  UserRank({
    required this.userId,
    required this.rank,
    required this.points,
  });
}

// UserSettings model
@freezed
class UserSettings with _$UserSettings{
  const factory UserSettings ({
    String? filterLayout,
    @Default([]) List<dynamic> notifications,
    Map<String, String>? privacy,
    Map<String, String>? preferences,
    Map<String, List<dynamic>>? contentDiscovery,
    Map<String, dynamic>? communication,
    Map<String, dynamic>? personalization,
    List<dynamic>? settings,
    @Default(false) Map<String, bool> onboarding,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

}

/// Collective model
class Collective {
  final String? id;
  final String? description;
  final String uniqueId;
  final String? userId;
  final String? email;
  final String entity;
  final List<dynamic> admin;
  final String? firstName;
  final String? lastName;
  final String? photoURL;
  final String? city;
  final String? displayName;
  final String? docRef;
  final String? state;
  final String? country;
  final String? postId;
  final String? postalCode;
  final bool? emailVerified;
  final bool? emailServiceAgreement;
  final dynamic geohash;
  final num radius;
  final num longitude;
  final num latitude;
  final String? phoneNumber;
  final bool? isAnonymous;
  final List<dynamic>? providerData;
  final String? refreshToken;
  final dynamic createdAt;
  final dynamic updatedAt;
  final List<Events>? events;
  final String status;
  final List<Jobs>? jobs;
  final List<dynamic>? orders;
  final List<AppliedJobs>? applications;
  final List<GroupUser>? groups;
  final List<Follower>? followers;
  final List<Following>? following;

  Collective({
    this.id,
    this.description,
    required this.uniqueId,
    this.userId,
    this.email,
    required this.entity,
    required this.admin,
    this.firstName,
    this.lastName,
    this.photoURL,
    this.city,
    this.displayName,
    this.docRef,
    this.state,
    this.country,
    this.postId,
    this.postalCode,
    this.emailVerified,
    this.emailServiceAgreement,
    required this.geohash,
    required this.radius,
    required this.longitude,
    required this.latitude,
    this.phoneNumber,
    this.isAnonymous,
    this.providerData,
    this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    this.events,
    required this.status,
    this.jobs,
    this.orders,
    this.applications,
    this.groups,
    this.followers,
    this.following,
  });

  factory Collective.fromJson(Map<String, dynamic> json) {
    return Collective(
      id: json['id'],
      description: json['description'],
      uniqueId: json['uniqueId'],
      userId: json['userId'],
      email: json['email'],
      entity: json['entity'],
      admin: List<dynamic>.from(json['admin']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      photoURL: json['photoURL'],
      city: json['city'],
      displayName: json['displayName'],
      docRef: json['docRef'],
      state: json['state'],
      country: json['country'],
      postId: json['postId'],
      postalCode: json['postalCode'],
      emailVerified: json['emailVerified'],
      emailServiceAgreement: json['emailServiceAgreement'],
      geohash: json['geohash'],
      radius: json['radius'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      phoneNumber: json['phoneNumber'],
      isAnonymous: json['isAnonymous'],
      providerData: json['providerData'],
      refreshToken: json['refreshToken'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      events: (json['events'] as List?)?.map((eventJson) => Events.fromJson(eventJson)).toList(),
      status: json['status'],
      jobs: (json['jobs'] as List?)?.map((jobJson) => Jobs.fromJson(jobJson)).toList(),
      orders: json['orders'],
      applications: (json['applications'] as List?)?.map((applicationJson) => AppliedJobs.fromJson(applicationJson)).toList(),
      groups: (json['groups'] as List?)?.map((groupJson) => GroupUser.fromJson(groupJson)).toList(),
      followers: (json['followers'] as List?)?.map((followerJson) => Follower.fromJson(followerJson)).toList(),
      following: (json['following'] as List?)?.map((followingJson) => Following.fromJson(followingJson)).toList(),
    );
  }
}

// Events model
@JsonSerializable()
class Events {
  final String id;
  final dynamic createdAt;
  final String description;
  final dynamic endDate;
  final String location;
  final dynamic startDate;
  final String status;
  final String title;
  final dynamic updatedAt;
  final String userId;

  Events({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.endDate,
    required this.location,
    required this.startDate,
    required this.status,
    required this.title,
    required this.updatedAt,
    required this.userId,
  });


  factory Events.fromJson(Map<String, dynamic> json) => _$EventsFromJson(json);

  Map<String, dynamic> toJson() => _$EventsToJson(this);
}

// Follower model
class Follower {
  final String id; // Assuming id will always be a string
  final String userId;
  final List<String>? followerIds;
  final String photoURL;
  final String status;
  final dynamic timestamp;

  Follower({
    required this.id,
    required this.userId,
    this.followerIds,
    required this.photoURL,
    required this.status,
    required this.timestamp,
  });

  factory Followers.fromJson(Map<String, dynamic> json) => _$FollowersFromJson(json); // Keep this one

  Map<String, dynamic> toJson() => _$FollowersToJson(this);
}

// Following model
@JsonSerializable()
class Following {
  final int id;
  final String userId;
  final List<String>? followingIds;
  final String? photoURL;
  final String status;
  final dynamic timestamp;

  Following({
    required this.id,
    required this.userId,
    this.followingIds,
    this.photoURL,
    required this.status,
    required this.timestamp,
  });

  factory Following.fromJson(Map<String, dynamic> json) => _$FollowingFromJson(json); // Keep this one

  Map<String, dynamic> toJson() => _$FollowingToJson(this);
}

// Jobs model
@JsonSerializable()
class Jobs {
  final String id;
  final dynamic createdAt;
  final String description;
  final String experience;
  final String location;
  final AuthUser owner;
  final String salary;
  final String status;
  final String title;
  final String type;
  final dynamic updatedAt;
  final String userId;
  final List<AuthUser>? applicants;

  Jobs({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.experience,
    required this.location,
    required this.owner,
    required this.salary,
    required this.status,
    required this.title,
    required this.type,
    required this.updatedAt,
    required this.userId,
    this.applicants,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) => _$JobsFromJson(json);
  Map<String, dynamic> toJson() => _$JobsToJson(this);
}

// AppliedJobs model
@JsonSerializable()
class AppliedJobs {
  final String id;
  final dynamic createdAt;
  final String description;
  final String experience;
  final String location;
  final AuthUser owner;
  final String salary;
  final String status;
  final String title;
  final String type;
  final dynamic updatedAt;
  final String userId;

  AppliedJobs({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.experience,
    required this.location,
    required this.owner,
    required this.salary,
    required this.status,
    required this.title,
    required this.type,
    required this.updatedAt,
    required this.userId,
  });

  factory AppliedJobs.fromJson(Map<String, dynamic> json) {
    return AppliedJobs(
      id: json['id'],
      createdAt: json['createdAt'],
      description: json['description'],
      experience: json['experience'],
      location: json['location'],
      owner: AuthUser.fromJson(json['owner']),
      salary: json['salary'],
      status: json['status'],
      title: json['title'],
      type: json['type'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
    );
  }
  factory AppliedJobs.fromJson(Map<String, dynamic> json) => _$AppliedJobsFromJson(json);
  Map<String, dynamic> toJson() => _$AppliedJobsToJson(this);
}

// TeamAdmin model
class TeamAdmin {
  final List<dynamic> role;
  final List<Team> team; // Assuming you have a Team model defined
  final String? email;
  final String? mobile;
  final String? teamLogo;
  final String? website;

  TeamAdmin({
    required this.role,
    required this.team,
    this.email,
    this.mobile,
    this.teamLogo,
    this.website,
  });

  factory TeamAdmin.fromJson(Map<String, dynamic> json) {
    return TeamAdmin(
      role: List<dynamic>.from(json['role']),
      team: (json['team'] as List).map((teamJson) => Team.fromJson(teamJson)).toList(), // Assuming you have a Team.fromJson constructor
      email: json['email'],
      mobile: json['mobile'],
      teamLogo: json['teamLogo'],
      website: json['website'],
    );
  }
}

// GroupUser model
@JsonSerializable()
class GroupUser {
  final String groupId;
  final String groupName;
  final String groupDescription;
  final String? groupImageUrl;
  final String groupUrl;
  final String joined;
  final String updatedAt;
  final bool administrator;
  final bool canPost;

  GroupUser({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    this.groupImageUrl,
    required this.groupUrl,
    required this.joined,
    required this.updatedAt,
    required this.administrator,
    required this.canPost,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) => _$GroupUserFromJson(json); // Keep this one

  Map<String, dynamic> toJson() => _$GroupUserToJson(this);
}

// Sale model
class Sale {
  final String id;
  final String title;
  final num amount;
  final String currency;
  final String description;
  final String docRef;
  final int quantity;
  final String paymentIntent;
  final String shippingMethod;
  final num shippingCost;
  final String status;
  final dynamic timestamp;
  final String userId;

  Sale({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.description,
    required this.docRef,
    required this.quantity,
    required this.paymentIntent,
    required this.shippingMethod,
    required this.shippingCost,
    required this.status,
    required this.timestamp,
    required this.userId,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      currency: json['currency'],
      description: json['description'],
      docRef: json['docRef'],
      quantity: json['quantity'],
      paymentIntent: json['paymentIntent'],
      shippingMethod: json['shippingMethod'],
      shippingCost: json['shippingCost'],
      status: json['status'],
      timestamp: json['timestamp'],
      userId: json['userId'],
    );
  }
}