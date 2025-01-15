import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/answers_app/services/answers_service.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({Key? key}) : super(key: key);

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask a Question'),
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
                decoration: const InputDecoration(labelText: 'Question Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question title';
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
                    _askQuestion();
                  }
                },
                child: const Text('Ask Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _askQuestion() async {
    // TODO: Implement asking question logic
    Future<void> _askQuestion() async {
      try {
        final question = Question(
          id: '', // Generate a unique ID
          title: _titleController.text,
          description: _descriptionController.text,
          askedBy: _authService.getCurrentUser()!, // Get the current user
          answers: [], // Initially, there are no answers
          // ... other fields (askedDate, votes, etc.)
        );

        await QuestionService().createQuestion(question);

        // Show a success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question asked successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error asking question: $e')),
        );
      }
    }
  }
}