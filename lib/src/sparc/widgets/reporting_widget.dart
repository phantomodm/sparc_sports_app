import 'package:flutter/material.dart';

class ReportWidget extends StatelessWidget {
  final dynamic entity;
  final VoidCallback onReport;

  const ReportWidget({Key? key, required this.entity, required this.onReport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.flag_outlined),
      onPressed: () {
        // TODO: Show a confirmation dialog or directly call onReport
        onReport();
      },
    );
  }
}