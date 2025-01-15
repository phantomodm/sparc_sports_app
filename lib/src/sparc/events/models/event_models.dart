import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  factory Event({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    required String groupId,
    Organizer? organizer,
    String? category,
    double? latitude,
    double? longitude,
  }) = _Event;

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      location: map['location'] as String,
      groupId: map['groupId'] as String,
      organizer: map['organizer'] != null ? Organizer.fromMap(map['organizer'] as Map<String, dynamic>) : null,
      category: map['category'] as String?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}