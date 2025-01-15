import 'package:flutter/material.dart';

class CreateGroupChatScreen extends StatefulWidget {
  const CreateGroupChatScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupChatScreen> createState() => _CreateGroupChatScreenState();
}

class _CreateGroupChatScreenState extends State<CreateGroupChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _membersController = TextEditingController();

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
      // Parse member IDs or emails
      final members = _membersController.text
          .split(',')
          .map((member) => member.trim())
          .where((member) => member.isNotEmpty)
          .toList();

      // TODO: Validate member IDs or emails

      final groupChat = Chat(
        id: const Uuid().v4(), // Generate a unique ID
        type: 'group',
        name: _nameController.text,
        members: members,
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