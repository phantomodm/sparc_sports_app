// meetup_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/sparc/meetups/bloc/meetup_bloc.dart';
import 'package:sparc_sports_app/src/sparc/meetups/models/meetup_models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MeetupDetailsScreen extends StatelessWidget {
  final Meetup meetup;

  const MeetupDetailsScreen({Key? key, required this.meetup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meetup.title ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meetup.title,
              style: AppThemes.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              meetup.description,
              style: AppThemes.bodyText1,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Date', meetup.date.toString()),
            _buildDetailRow('Time', _formatTime(meetup.date, context)),
            _buildDetailRow('Location', meetup.location),
            const SizedBox(height: 16),
            const Text(
              'Attendees',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAttendeeList(meetup.attendees),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // TODO: Implement "Join" or "RSVP" functionality
                  final success = await _createMeetup(context); // Await _createMeetup
                  if (success) { // Show notification only if creation was successful
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meetup created successfully!')),
                    );
                    // TODO: Navigate back
                  }
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Join Meetup'),
              ),
            ),
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(meetup.latitude, meetup.longitude), // Use meetup coordinates
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(meetup.id),
                  position: LatLng(meetup.latitude, meetup.longitude),
                  infoWindow: InfoWindow(title: meetup.title),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  String _formatTime(DateTime dateTime, BuildContext context) {
    // Format the time as needed (e.g., "10:00 AM")
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  Widget _buildAttendeeList(List<AuthUser> attendees) {
    return Expanded(
      child: ListView.builder(
        itemCount: meetup.attendees.length,
        itemBuilder: (context, index) {
          final attendee = meetup.attendees[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(attendee.profileImageUrl),
            ),
            title: Text(attendee.displayName ?? ''),
          );
        },
      ),
    );
  }

  // Update _createMeetup to return a Future<bool>
  Future<bool> _createMeetup(BuildContext context) async {
    try {
      final meetup =
      Meetup(id: '', title: '', description: '', date: null, location:'', attendees: [] );
      context.read<MeetupBloc>().add(CreateMeetup(meetup));
      return true; // Return true on success
    } catch (e) {
      // TODO: Handle error (e.g., show error message)
      return false; // Return false on error
    }
  }
}