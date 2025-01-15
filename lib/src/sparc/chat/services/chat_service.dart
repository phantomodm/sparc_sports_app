// chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(ChatMessage message) async {
    try {
      final chatRef = _firestore.collection('chats').doc(message.chatId);
      await chatRef.collection('messages').add(message.toMap());
    } catch (e) {
      print('Error sending message: $e');
      // TODO: Handle error appropriately
    }
  }

  Stream<List<ChatMessage>> getMessagesForChat(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  Future<List<Chat>> getChatsForUser(String userId) async {
    final snapshot = await _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .get();
    return snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList();
  }

  Future<List<Chat>> getChatsForUser(String userId) async {
    final snapshot = await _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .get();
    return snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList();
  }

  Future<List<Chat>> getChannels() async {
    final snapshot = await _firestore
        .collection('chats')
        .where('type', isEqualTo: 'channel')
        .get();
    return snapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList();
  }
// ... other methods for creating channels, group chats, etc.
}
