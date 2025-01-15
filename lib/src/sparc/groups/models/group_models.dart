part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  factory Group({
    required String id,
    required String name,
    required String description,
    required User createdBy,
    required List<User> members,
    String? groupPhoto,
    required String category,
    required List<String> invitedUsers,
  }) = _Group;

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      createdBy: User.fromMap(map['createdBy'] as Map<String, dynamic>),
      members: (map['members'] as List<dynamic>).map((e) => User.fromMap(e as Map<String, dynamic>)).toList(),
      groupPhoto: map['groupPhoto'] as String?,
      category: map['category'] as String,
      invitedUsers: (map['invitedUsers'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
@JsonSerializable
class GroupPost {
  final String id;
  final String groupId;
  final String content;
  final User author;
  final DateTime timestamp;
  final List<GroupPostReply> replies;

  GroupPost({
    required this.id,
    required this.groupId,
    required this.content,
    required this.author,
    required this.timestamp,
    this.replies = const [],
  });
  factory GroupPost.fromJson(Map<String, dynamic> json) => _$GroupPostFromJson(json);

  Map<String, dynamic> toJson() => _$GroupPostToJson(this);
// ... factory constructors for fromMap and toMap (if using Firestore)
}