import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.info_outline,
                size: 80.0,
                color: Colors.black38,
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Sorry, the page you have requested is not available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Go back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
