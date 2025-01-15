// add_job_screen.dart

import 'package:flutter/material.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({Key? key}) : super(key: key);

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _categoryController = TextEditingController();
  final _salaryController = TextEditingController();
  final _applicationDeadlineController = TextEditingController();
  DateTime? _selectedApplicationDeadline;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _categoryController.dispose();
    _salaryController.dispose();
    _applicationDeadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _applicationDeadlineController,
                decoration: const InputDecoration(labelText: 'Application Deadline'),
                onTap: () => _selectApplicationDeadline(context),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(labelText: 'Requirements'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter requirements';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addJob();
                  }
                },
                child: const Text('Add Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectApplicationDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedApplicationDeadline) {
      setState(() {
        _selectedApplicationDeadline = picked;
        _applicationDeadlineController.text =
        "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _addJob() async {
    try {
      final job = Job(
        id: '', // Generate a unique ID (you'll need to implement this)
        title: _titleController.text,
        company: _companyController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        requirements: _requirementsController.text,
        category: _categoryController.text,
        salary: _salaryController.text.isNotEmpty
            ? double.parse(_salaryController.text)
            : null,
        applicationDeadline: _selectedApplicationDeadline != null
            ? Timestamp.fromDate(_selectedApplicationDeadline!)
            : null,
      );

      await JobService().createJob(job); // Assuming you have a createJob method in your JobService

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding job: $e')),
      );
    }
  }
}