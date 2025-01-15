part 'channel.freezed.dart';
part 'channel.g.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  String? chatId;
  String? type;
  String? fileUrl;
  String? videoUrl;
  String? imageUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.chatId,
    this.type,
    this.fileUrl,
    this.videoUrl,
    this.imageUrl, required String name
  });

// ... factory constructors for fromMap and toMap (if using Firestore)
}

@freezed
class Channel with _$Channel {
  factory Channel({
    required String id,
    required String name,
    String? description,
    required String createdBy,
    required List<User> members,
    String? groupPhoto,
  }) = _Channel;

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdBy: map['createdBy'] as String,
      members: (map['members'] as List<dynamic>).map((e) => User.fromMap(e as Map<String, dynamic>)).toList(),
      groupPhoto: map['groupPhoto'] as String?,
    );
  }

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
}