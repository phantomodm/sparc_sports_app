import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart'
import 'package:sparc_sports_app/src/core/resources/widgests/filter_widget.dart';;
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/sparc/events/services/events_service.dart';
import 'package:sparc_sports_app/src/sparc/jobs/services/jobs_services.dart';

class JobBoardScreen extends StatefulWidget {
  const JobBoardScreen({Key? key}) : super(key: key);

  @override
  State<JobBoardScreen> createState() => _JobBoardScreenState();
}

class _JobBoardScreenState extends State<JobBoardScreen> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _allJobs = [];
  List<dynamic> _filteredJobs = [];
  bool _isRemoteFilter = false;
  String _selectedCategory = 'all';
  int _currentOffset = 0;
  final int _jobsPerBatch = 20;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // TODO: Load more jobs
      _loadMoreJobs();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _fetchJobs() async {
    final jobs = await JobService().getJobs();
    setState(() {
      _allJobs = jobs;
      _filteredJobs = jobs;
      _currentOffset = _jobsPerBatch;
    });
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterWidget(
          filterOptions: {
            'Category': ['Technology', 'Design', 'Marketing'],
            'Location': ['Remote', 'New York', 'London'],
            'Experience Level': ['Entry Level', 'Mid Level', 'Senior Level'],
          },
          onFilterChanged: (filters) {
            // TODO: Apply filters to job list
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterModal(context), // Call _showFilterModal
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search jobs...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (text) {
                  // TODO: Update the job listings based on search text
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children:[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return _buildJobCard(job);
              },
            ),
          ),
          if (_isLoadingMore) // Show loading indicator conditionally
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
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

  Widget _buildJobCard(dynamic job) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          job.title,
          style: AppThemes.headline6,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.company,
              style: AppThemes.subtitle1,
            ),
            Text(
              job.location,
              style: AppThemes.subtitle2,
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to job details screen
        },
      ),
    );
  }

  Future<void> _loadMoreJobs() async {
    if (!_isLoadingMore) { // Prevent multiple loads
      setState(() {
        _isLoadingMore = true;
      });
      final jobs = await JobService().getJobs(
        limit: _jobsPerBatch,
        offset: _currentOffset,
      );
      setState(() {
        _allJobs.addAll(jobs);
        _filteredJobs.addAll(jobs);
        _currentOffset += _jobsPerBatch;
        _isLoadingMore = false;
      });
    }
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filter Options'),
                  CheckboxListTile(
                    title: const Text('Remote'),
                    value: _isRemoteFilter,
                    onChanged: (value) {
                      setState(() {
                        _isRemoteFilter = value!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Categories')),
                      DropdownMenuItem(value: 'technology', child: Text('Technology')),
                      DropdownMenuItem(value: 'design', child: Text('Design')),
                      // ... add more categories
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filteredJobs = _allJobs.where((job) {
                          if (_isRemoteFilter && !job.location.toLowerCase().contains('remote')) {
                            return false;
                          }
                          if (_selectedCategory != 'all' && job.category != _selectedCategory) {
                            return false;
                          }
                          return true;
                        }).toList();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // In add_event_screen.dart

  Future<void> _addEvent() async {
    try {
      final event = Event(
        id: '', // Generate a unique ID (you'll need to implement this)
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate!,
        location: _locationController.text,
        // ... other fields (organizer, category, etc.)
      );

      await EventService().createEvent(event); // Assuming you have a createEvent method in your EventService

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding event: $e')),
      );
    }
  }

}