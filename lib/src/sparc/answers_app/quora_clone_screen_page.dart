

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/sparc/answers_app/questions_details_screen_page.dart';
import 'package:sparc_sports_app/src/sparc/models/post_model.dart';
import 'package:sparc_sports_app/src/sparc/widgets/reporting_widget.dart';
import 'package:sparc_sports_app/src/sparc/widgets/share_widget.dart';

class QuoraCloneScreen extends StatefulWidget {
  const QuoraCloneScreen({Key? key}) : super(key: key);

  @override
  State<QuoraCloneScreen> createState() => _QuoraCloneScreenState();
}
class _QuoraCloneScreenState extends State<QuoraCloneScreen> {
  // ... (other variables)
  String _selectedFilter = 'all';
  String _selectedSort = 'date';
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final questions = await QuestionService().getQuestions();
    setState(() {
      _questions = questions;
    });
  }

  // ... (initState and _fetchQuestions)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quora Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSortModal(context),
          ),
        ],
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return Column(
            children: [
              _buildQuestionCard(question),
              const Divider(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AskQuestionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(question.title, style: AppThemes.headline6,),
        subtitle: Column( // Wrap the subtitle in a Column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppThemes.bodyText2,
            ),
            Text(
              'Reputation: ${question.askedBy.reputation}',
              style: AppThemes.caption,
            ),
          ],
        ),
        leading: SizedBox( // Add space for badge image
          width: 32,
          height: 32,
          child: question.askedBy.badge != null // Assuming User has a badge property
              ? Image.network(question.askedBy.badge!.imageUrl) // Assuming Badge has imageUrl
              : const Icon(Icons.person), // Default icon if no badge
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showQuestionOptionsModal(context, question),
            ),
            ReportWidget(
              entity: question,
              onReport: () {
                // TODO: Implement report functionality in QuestionService
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDetailsScreen(question: question),
            ),
          );
        },
      ),
    );
  }

  void _showFilterSortModal(BuildContext context) {
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
                  const Text('Filter and Sort'),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Categories')),
                      // ... add more filter options
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                        // TODO: Update _questions based on filter
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
                        // TODO: Update _questions based on sort
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context), // Close the modal
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showQuestionOptionsModal(BuildContext context, Question question) {
    bool isBookmarked = false;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                // TODO: Implement report functionality
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const TextField(
                      decoration: InputDecoration(hintText: 'Reason for reporting...')
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Report')
                      )
                    ]
                  )
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add_outlined),
              title: const Text('Bookmark'),
              onTap: () {
                // TODO: Implement bookmark functionality
              },
            ),
            ShareWidget(
                entity: entity,
                onShare: onShare
            ),
            ListTile(
              leading: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_add_outlined),
              title: const Text('Bookmark'),
              onTap: () {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                // TODO: Update bookmark status in local storage or database
              },
            ),
          ],
        );
      },
    );
  }
}