import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/sparc/answers_app/services/answers_service.dart';
import 'package:sparc_sports_app/src/sparc/models/post_model.dart';
import 'package:sparc_sports_app/src/sparc/widgets/reporting_widget.dart';
import 'package:sparc_sports_app/src/sparc/widgets/vote_widget.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final Question question;

  const QuestionDetailsScreen({Key? key, required this.question})
      : super(key: key);

  @override
  State<QuestionDetailsScreen> createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Answer> _answers = [];

  @override
  void initState() {
    super.initState();
    _answers = widget.question.answers; // Initialize with existing answers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title!,
              style: AppThemes.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              'Asked by: ${question.askedBy.userName}',
              style: AppThemes.subtitle2,
            ),
            const SizedBox(height: 16),
            Text(
              question.description,
              style: AppThemes.bodyText1,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Answers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AnimatedList(
              key: _listKey,
              initialItemCount: _answers.length,
              itemBuilder: (BuildContext context, int index,
                  Animation<double> animation) {
                return FadeTransition(
                  // Add FadeTransition
                  opacity: animation,
                  child: _buildAnswerTile(_answers[index], context),
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showAddAnswerModal(context),
              // Show modal for adding answer
              child: const Text('Add Answer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerTile(Answer answer, BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(answer.text),
          subtitle: Column(
            // Wrap the subtitle in a Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _showUserActionsModal(context, answer.answeredBy),
                child: Text('Answered by: ${answer.answeredBy.userName}'),
              ),
              Text(
                'Reputation: ${answer.answeredBy.reputation}',
                style: AppThemes.caption,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VoteWidget(
                entity: answer,
                onUpvote: () {
                  QuestionService().upvoteAnswer(question.id, answer.id);
                },
                onDownvote: () {
                  QuestionService().downvoteAnswer(question.id, answer.id);
                },
              ),
              const SizedBox(width: 8),
              Text('${answer.votes}'),
              const SizedBox(width: 16),
              ReportWidget(
                entity: answer,
                onReport: () {},
              ),
              // IconButton( // You might want to uncomment this later
              //   icon: const Icon(Icons.more_vert),
              //   onPressed: () => _showAnswerOptionsModal(context, answer),
              // ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _showAddAnswerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust padding for keyboard
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add Answer'),
                  const TextField(
                    decoration:
                        InputDecoration(hintText: 'Write your answer...'),
                    maxLines: null,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // TODO: Implement add answer logic
                      try {
                        final answer = {
                          id: '',
                          // Generate a unique ID
                          text: _answerController.text,
                          answeredBy: _authService.getCurrentUser()!,
                          // Get the current user
                          // ... other fields (answeredDate, votes, etc.)
                        };
                        await QuestionService().addAnswer(question.id,
                            answer); // Add the answer to the question
                        Navigator.pop(context);
                        // Show a success message and close the modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Answer added successfully!')),
                        );
                      } catch (e) {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding answer: $e')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _showAnswerOptionsModal(BuildContext context, Answer answer) {
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                // TODO: Implement share functionality
                Share.share('Check out this answer: ${answer.text}');
              },
            ),
          ],
        );
      },
    );
  }

  void _showUserActionsModal(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('View Profile'),
              onTap: () {
                // TODO: Navigate to user profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(user: user), // Assuming you have a UserProfileScreen
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Follow'),
              onTap: () {
                // TODO: Implement follow functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              onTap: () {
                // TODO: Implement message functionality
              },
            ),
          ],
        );
      },
    );
  }
}
