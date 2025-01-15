import 'package:flutter/material.dart';

class VoteWidget extends StatefulWidget {
  final dynamic entity;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const VoteWidget({Key? key, required this.entity, required this.onUpvote, required this.onDownvote}) : super(key: key);

  @override
  State<VoteWidget> createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {
  bool _isUpvoted = false;
  bool _isDownvoted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: AnimatedContainer( // Wrap the icon in AnimatedContainer
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(_isUpvoted ? 1.2 : 1.0),
            child: Icon(_isUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined),
          ),
          onPressed: () {
            setState(() {
              _isUpvoted = !_isUpvoted;
              _isDownvoted = false;
            });
            widget.onUpvote();
          },
        ),
        IconButton(
          icon: AnimatedContainer( // Wrap the icon in AnimatedContainer
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(_isDownvoted ? 1.2 : 1.0),
            child: Icon(_isDownvoted ? Icons.thumb_down : Icons.thumb_down_outlined),
          ),
          onPressed: () {
            setState(() {
              _isDownvoted = !_isDownvoted;
              _isUpvoted = false;
            });
            widget.onDownvote();
          },
        ),
      ],
    );
  }
}