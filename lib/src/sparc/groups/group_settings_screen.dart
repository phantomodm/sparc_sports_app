// group_settings_screen.dart

import 'package:flutter/material.dart';

class GroupSettingsScreen extends StatefulWidget {
  final Group group;

  const GroupSettingsScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupSettingsScreen> createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group.name;
    _descriptionController.text = widget.group.description;
  }

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
        title: const Text('Group Settings'),
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
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
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
              const SizedBox(height: 16),
              // TODO: Add option to change group avatar
              const SizedBox(height: 16),
              const Text(
                'Manage Members',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.group.members.length,
                itemBuilder: (context, index) {
                  final member = widget.group.members[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member.profileImageUrl),
                    ),
                    title: Text(member.userName),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        // TODO: Implement remove member functionality
                      },
                    ),
                  );
                },
              ),
              // TODO: Add section to manage group members
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateGroupSettings();
                  }
                },
                child: const Text('Update Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateGroupSettings() async {
    try {
      final updatedGroup = widget.group.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
      );

      await GroupService().updateGroup(updatedGroup);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group settings updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating group settings: $e')),
      );
    }
  }
}