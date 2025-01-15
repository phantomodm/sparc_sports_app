import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_models.freezed.dart';
part 'chat_message_models.g.dart';


@freezed
class Chat with _$Chat {

  factory Chat({
    required String id,
    required String type, // 'global', 'channel', 'direct', 'group'
    String? name,
    required List<String> members,
    ChatMessage? lastMessage,
  }) = _Chat;

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      type: map['type'] as String,
      name: map['name'] as String?,
      members: (map['members'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: map['lastMessage'] != null ? ChatMessage.fromMap(
          map['lastMessage'] as Map<String, dynamic>) : null,
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

@JsonSerializable()
class ChatMessage  {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final String chatId;
  final String type;
  final String? fileUrl;
  final String? videoUrl;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.chatId,
    required this.type,
    this.fileUrl,
    this.videoUrl,
    this.imageUrl,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      chatId: map['chatId'] as String,
      type: map['type'] as String,
      fileUrl: map['fileUrl'] as String?,
      videoUrl: map['videoUrl'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
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