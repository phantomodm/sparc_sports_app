// create_channel_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/chat/services/chat_service.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({Key? key}) : super(key: key);

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
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
                decoration: const InputDecoration(labelText: 'Channel Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a channel name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createChannel();
                  }
                },
                child: const Text('Create Channel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createChannel() async {
    try {
      final channel = ChatMessage(
        id: '', // Generate a unique ID
        type: 'channel',
        name: _nameController.text,
        timestamp: ,

        members: , senderId: '', receiverId: '', // Initially, no members in the channel
        // ... (optional) add description and other fields
      );

      await ChatService().createChannel(channel);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Channel created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(