import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
  }

  Future<List<Event>> getEventsForGroup(String groupId) async {
    final snapshot = await _firestore.collection('events')
        .where('groupId', isEqualTo: groupId)
        .get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
  }

  Future<void> createEvent(Event event) async {
    try {
      await _firestore.collection('events').add(event.toMap());
    } catch (e) {
      print('Error creating event: $e');
      // TODO: Handle error (e.g., throw an exception or show an error message)
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      print('Error updating event: $e');
      // TODO: Handle error
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
      // TODO: Handle error
    }
  }

// ... other methods for filtering, searching, etc.
}