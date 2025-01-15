// meetup_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';

class Meetup {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final List<AuthUser> attendees; // Assuming you have a AuthUser model

  Meetup({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.attendees,
  });

  // Factory constructor to create a Meetup from a map (e.g., from Firestore)
  factory Meetup.fromMap(Map<String, dynamic> map) {
    return Meetup(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: (map['date'] as Timestamp).toDate(),
      location: map['location'] as String,
      attendees: (map['attendees'] as List<dynamic>)
          .map((e) => AuthUser.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert a Meetup to a map (e.g., for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'attendees': attendees.map((e) => e.toMap()).toList(),
    };
  }
}