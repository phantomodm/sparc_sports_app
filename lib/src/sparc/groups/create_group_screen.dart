// create_group_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/groups/services/groups_service.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _selectedImage;
  String? _selectedCategory;
  final List<String> _categories = ['Category 1', 'Category 2', 'Category 3']; // Replace with your actual categories


  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
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
        title: const Text('Create Group'),
      ),
      body: Column(
      children: [
      Form(
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createGroup();
                  }
                },
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Category'),
          value: _selectedCategory,
          items: _categories.map((category) => DropdownMenuItem(
            value: category,
            child: Text(category),
          ))
              .toList(),
          onChanged: (value) => setState(() => _selectedCategory = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      const SizedBox(height: 16),
      // Image placeholder or button
      GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _selectedImage != null // Display selected image or placeholder
              ? Image.file(_selectedImage!)
              : const Icon(Icons.add_a_photo),
        ),
      ),
      ],
      )
    );
  }

  Future<void> _createGroup() async {
    try {
      final group = Group(
        id: '', // Generate a unique ID
        name: _nameController.text,
        description: _descriptionController.text,
        createdBy: _authService.getCurrentUser()!, // Get the current user
        members: [_authService.getCurrentUser()!], // Initially, the creator is the only member
        // ... other fields (createdDate, groupPhoto, etc.)
      );

      await GroupService().createGroup(group);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating group: $e')),
      );
    }
  }
}