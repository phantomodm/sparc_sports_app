// chat_list_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/chat/chat_screen.dart';
import 'package:sparc_sports_app/src/sparc/chat/create_channel_screen.dart';
import 'package:sparc_sports_app/src/sparc/chat/create_group_chat_screen.dart';
import 'package:sparc_sports_app/src/sparc/chat/models/chat_message_models.dart';
import 'package:sparc_sports_app/src/sparc/chat/services/chat_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    final chats = await ChatService().getChatsForUser(_authService.getCurrentUser()!.uid); // Fetch chats for the current user
    setState(() {
      _chats = chats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // TODO: Navigate to UserSelectionScreen to choose a user
            },
          ),
        ],
      ),
      body: DefaultTabController( // Use DefaultTabController for tabs
        length: 4, // Number of tabs (global, channels, direct, group)
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Global'),
                Tab(text: 'Channels'),
                Tab(text: 'Direct'),
                Tab(text: 'Group'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildChatList(ChatService().getGlobalChatMessages()), // Assuming you have a getGlobalChatMessages method
                  _buildChatList(ChatService().getChannels()),
                  _buildChatList(ChatService().getDirectChatsForUser(_authService.getCurrentUser()!.uid)), // Add this for direct chats
                  _buildChatList(ChatService().getGroupChatsForUser(_authService.getCurrentUser()!.uid)), // Add this for group chats
                  // ... (add sections for direct and group chats)
                ],
              ),
            ),
          ],
        ),
      ),
        // In chat_list_screen.dart

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.public),
                      title: const Text('Create Channel'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateChannelScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: const Text('Create Group Chat'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateGroupChatScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),,
    );
  }

  Widget _buildChatList(Future<List<Chat>> chatFuture) {
    return FutureBuilder<List<Chat>>(
      future: chatFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No chats found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data![index];
              return _buildChatTile(chat);
            },
          );
        }
      },
    );
  }

  Widget _buildChatTile(dynamic chat) {
    return FutureBuilder(
        future: chatFuture,
        builder: builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.dta!.isEmpty) {
            return const Center(
              child: Text("No Chats found. l")
            )
          }
    })
    return ListTile(
      leading: CircleAvatar(
        // TODO: Display chat avatar (if available)
      ),
      title: Text(chat.type), // Display chat name or "Unnamed Chat"

      onTap: () {
        // Navigate to ChatScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chat: chat),
          ),
        );
      },
    );
  }
}