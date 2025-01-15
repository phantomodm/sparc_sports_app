// create_meetup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/sparc/meetups/bloc/meetup_bloc.dart';
import 'package:sparc_sports_app/src/sparc/meetups/models/meetup_models.dart'; // Import your theme and models

// ... (MeetupBloc and MeetupState classes)

class CreateMeetupScreen extends StatefulWidget {
  const CreateMeetupScreen({Key? key}) : super(key: key);

  @override
  State<CreateMeetupScreen> createState() => _CreateMeetupScreenState();
}

class _CreateMeetupScreenState extends State<CreateMeetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetupBloc, MeetupState>(
      listener: (context, state) {
        if (state is MeetupCreated) {
          // TODO: Show success message and navigate back
        } else if (state is MeetupError) {
          // TODO: Show error message
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Meetup'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView( // Wrap the content in SingleChildScrollView
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter meetup title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter meetup description',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'Select date',
                  ),
                  onTap: () => _selectDate(context),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    hintText: 'Select time',
                  ),
                  onTap: () => _selectTime(context),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter meetup location',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createMeetup(context);
                    }
                  },
                  child: const Text('Create Meetup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
        "${picked.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context); // Format the time
      });
    }
  }

  void _createMeetup(BuildContext context) {
    final meetup = Meetup(
      id: '', // Generate a unique ID (you'll need to implement this)
      title: _titleController.text,
      description: _descriptionController.text,
      date: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
      location: _locationController.text,
      attendees: [], // Initially, there are no attendees
    );
    context.read<MeetupBloc>().add(CreateMeetup(meetup));
  }
}