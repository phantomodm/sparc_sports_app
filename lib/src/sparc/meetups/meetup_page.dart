// meetup_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/sparc/meetups/bloc/meetup_bloc.dart';
import 'package:sparc_sports_app/src/sparc/meetups/models/meetup_models.dart';
import 'services/meetup_service.dart';

// ... (MeetupBloc and MeetupState classes)

class MeetupView extends StatefulWidget {
  const MeetupView({Key? key}) : super(key: key);

  @override
  State<MeetupView> createState() => _MeetupViewState();
}

class _MeetupViewState extends State<MeetupView> {
  String _selectedFilter = 'all';
  String _selectedSort = 'date';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetupBloc(meetupService: MeetupService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meetups', , style: Theme.of(context).textTheme.headline6),
          actions: [
            DropdownButton<String>(
              value: _selectedFilter, // Store the selected filter in a variable
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: 'thisWeek', child: Text('This Week')),
                // ... add more filter options
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                  // TODO: Update the MeetupBloc to fetch filtered meetups
                  _selectedFilter = value!;
                  context.read<MeetupBloc>().add(LoadMeetups(
                    filter: _selectedFilter,
                    sort: _selectedSort, // Include sort parameter
                  ));
                });
              },
            ),
            DropdownButton<String>(
              value: _selectedSort,
              items: const [
                DropdownMenuItem(value: 'date', child: Text('Date')),
                DropdownMenuItem(value: 'popularity', child: Text('Popularity')),
                // ... add more sort options
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                  // TODO: Update the MeetupBloc to sort meetups
                  _selectedSort = value!;
                  context.read<MeetupBloc>().add(LoadMeetups(
                    filter: _selectedFilter, // Include filter parameter
                    sort: _selectedSort,
                  ));
                });
              },
            ),
            Expanded( // Wrap the TextField in Expanded
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search meetups...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (text) {
                    // TODO: Update the MeetupBloc to filter meetups based on search text
                  },
                ),
              ),
            ),
          ]
        ),
        body: BlocBuilder<MeetupBloc, MeetupState>(
          builder: (context, state) {
            if (state is MeetupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MeetupLoaded) {
              if (state.meetups.isEmpty) { // Check for empty list
                return const Center(child: Text('No meetups found.'));
              } else {
                return _buildMeetupList(state.meetups);
              }
            } else if (state is MeetupError) {
              return Center(child: Text(state.error));
            } else {
              return Container();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to create meetup screen
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMeetupList(List<Meetup> meetups) {
    return ListView.builder(
      itemCount: meetups.length,
      itemBuilder: (context, index) {
        final meetup = meetups[index];
        return Column( // Wrap the Card in a Column
          children: [
            Card(
              child: ListTile(
                title: Text(meetup.title),
                subtitle: Text(meetup.description),
                onTap: () {
                  // TODO: Navigate to meetup details screen
                },
              ),
            ),
            const SizedBox(height: 16), // Add spacing between cards
          ],
        );
      },
    );
  }
}