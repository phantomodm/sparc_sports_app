// create_group_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/chat/services/chat_service.dart'; // Import your theme and models

class CreateGroupChatScreen extends StatefulWidget {
  const CreateGroupChatScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupChatScreen> createState() => _CreateGroupChatScreenState();
}

class _CreateGroupChatScreenState extends State<CreateGroupChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _membersController = TextEditingController(); // For adding members (comma-separated IDs or emails)

  @override
  void dispose() {
    _nameController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group Chat'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Group Chat Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group chat name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _membersController,
                decoration: const InputDecoration(
                  labelText: 'Members',
                  hintText: 'Enter member IDs or emails (comma-separated)',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createGroupChat();
                  }
                },
                child: const Text('Create Group Chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createGroupChat() async {
    try {
      // TODO: Parse member IDs or emails from _membersController.text
      final members = _membersController.text
          .split(',')
          .map((member) => member.trim())
          .where((member) => member.isNotEmpty)
          .toList();

      final groupChat = Chat(
        id: '', // Generate a unique ID
        type: 'group',
        name: _nameController.text,
        members: [], // Add parsed member IDs here
      );

      await ChatService().createGroupChat(groupChat);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group chat created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating group chat: $e')),
      );
    }
  }
}