import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:share_plus/share_plus.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('Check out this job: ${job.title} at ${job.company} - ${job.location} \n\n ${job.description}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: AppThemes.headline5,
            ),
            const SizedBox(height: 8),
            Text(
              '${job.company} - ${job.location}',
              style: AppThemes.subtitle1,
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(job.description),
          const SizedBox(height: 16),
          const Text(
            'Requirements',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement apply functionality
                  // 1. Check if the user is logged in
                  if (_authService.getCurrentUser() == null) {
                    // TODO: Navigate to login screen or show a login prompt
                    return;
                  }

                  // 2. (Optional) Collect application details
                  // ...

                  // 3. Submit the application
                  _jobService.applyForJob(job.id, _authService.getCurrentUser()!.uid); // Assuming you have a _jobService

                  // 4. Provide feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application submitted successfully!')),
                  );
                },
                child: const Text('Apply Now'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Company Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // TODO: Display company logo (e.g., using Image.network)
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.company, style: AppThemes.textTheme.subtitle1),
                    // TODO: Make company name tappable to open website
                    const SizedBox(height: 4),
                    // TODO: Display company description (if available)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}