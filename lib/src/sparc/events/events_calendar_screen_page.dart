import 'package:flutter/material.dart';
import 'package:sparc_sports_app/sparc_sports_app.dart'; // Import your theme and models
import 'package:table_calendar/table_calendar.dart'; // Import for the calendar widget

class EventsCalendarScreen extends StatefulWidget {
  const EventsCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventsCalendarScreen> createState() => _EventsCalendarScreenState();
}

class _EventsCalendarScreenState extends State<EventsCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> _events = {}; // Store events by date

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch events when the screen initializes
  }

  Future<void> _fetchEvents() async {
    final events = await EventService().getEvents(); // Fetch events from your EventService
    // Group events by date
    Map<DateTime, List<dynamic>> eventsByDate = {};
    for (var event in events) {
      final date = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      eventsByDate[date] = (eventsByDate[date] ?? [])..add(event);
    }
    setState(() {
      _events = eventsByDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _events[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final event = _events[_selectedDay]![index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( // Add this
        onPressed: () {
          // TODO: Navigate to AddEventScreen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventCard(dynamic  event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(event.description),
        onTap: () {
          // TODO: Navigate to event details screen
        },
      ),
    );
  }
}