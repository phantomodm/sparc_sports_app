// event_details_screen.dart

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import for Google Maps// Import your theme and models
import 'package:sparc_sports_app/src/core/themes/themes.dart'; // Import for adding events to calendar


class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: AppThemes.headline5,
            ),
            const SizedBox(height: 8),
            Text(
              event.description ?? '',
              style: AppThemes.bodyText1,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Start Date', event.startDate.toString()),
            _buildDetailRow('End Date', event.endDate.toString()),
            _buildDetailRow('Location', event.location ?? ''),
            const SizedBox(height: 16),
            // Display the map
            SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(event.latitude, event.longitude), // Assuming Event has latitude and longitude
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(event.id),
                    position: LatLng(event.latitude, event.longitude),
                    infoWindow: InfoWindow(title: event.title),
                  ),
                },
              ),
            ),
            const SizedBox(height: 16),
            // Display organizer details
            if (event.organizer != null) // Assuming Event has an organizer property
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(event.organizer!.profileImageUrl), // Assuming Organizer has profileImageUrl
                ),
                title: Text(event.organizer!.name), // Assuming Organizer has name
                subtitle: Text(event.organizer!.description), // Assuming Organizer has description
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Add to Calendar functionality
                final Event event = Event(
                  title: 'Event Title',
                  description: 'Event Description',
                  location: 'Event Location',
                  startDate: DateTime(2025, 1, 20, 10, 0, 0),
                  endDate: DateTime(2025, 1, 20, 12, 0, 0),
                );
                Add2Calendar.addEvent2Cal(event);
              },
              child: const Text('Add to Calendar'),
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
}