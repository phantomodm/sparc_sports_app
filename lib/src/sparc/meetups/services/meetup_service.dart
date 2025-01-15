// meetup_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparc_sports_app/src/sparc/meetups/models/meetup_models.dart';

class MeetupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch meetups from Firestore
  Future<List<Meetup>> getMeetups() async {
    final snapshot = await _firestore.collection('meetups').get();
    return snapshot.docs.map((doc) => Meetup.fromMap(doc.data())).toList();
  }

  // Create a new meetup in Firestore
  Future<void> createMeetup(Meetup meetup) async {
    await _firestore.collection('meetups').add(meetup.toMap());
  }

// ... (other methods for updating, deleting, etc.)
}