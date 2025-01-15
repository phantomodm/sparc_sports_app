// chat_screen.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:sparc_sports_app/src/core/services/image_service.dart';
import 'package:sparc_sports_app/src/core/services/user_service.dart';
import 'package:sparc_sports_app/src/sparc/chat/models/chat_message_models.dart';
import 'package:sparc_sports_app/src/sparc/chat/services/chat_service.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Add a function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Check file size (example: limit to 5MB)
      final fileSize = await File(pickedImage.path).length();
      if (fileSize > 5 * 1024 * 1024) {
        // Show error message for file size exceeding limit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image size exceeds the limit (5MB).')),
        );
        return;
      }

      // Upload image to storage
      final imageUrl = await ImageService().uploadImageToFirestore(
          pickedImage, 'chat_image_${generateUniqueId()}');

      if (imageUrl != null) {
        // Send image URL in chat message
        final currentUserId = _authService.getCurrentUser()!.uid;
        final message = ChatMessage(
          id: '',
          senderId: currentUserId,
          chatId: widget.chat.id,
          content: '',
          imageUrl: imageUrl,
          timestamp: DateTime.now(),
          type: 'image',
          receiverId: '',
        );

        try {
          await ChatService().sendMessage(message);
        } catch (e) {
          // Show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending message: $e')),
          );
        }
      } else {
        // Show an error message for image upload failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading image.')),
        );
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final XFile? pickedVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery);
    if (pickedVideo != null) {
      // Check file size (example: limit to 20MB)
      final fileSize = await File(pickedVideo.path).length();
      if (fileSize > 20 * 1024 * 1024) {
        // Show error message for file size exceeding limit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video size exceeds the limit (20MB).')),
        );
        return;
      }

      // Upload video to storage
      final videoUrl = await ImageService().uploadImageToFirestore(
          pickedVideo, 'chat_video_${generateUniqueId()}');

      if (videoUrl != null) {
        // Send video URL in chat message
        final currentUserId = _authService.getCurrentUser()!.uid;
        final message = ChatMessage(
          id: '',
          senderId: currentUserId,
          chatId: widget.chat.id,
          content: '',
          videoUrl: videoUrl,
          timestamp: DateTime.now(),
          type: 'video',
          receiverId: ''
        );

        try {
          await ChatService().sendMessage(message);
        } catch (e) {
          // Show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending message: $e')),
          );
        }
      } else {
        // Show an error message for video upload failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading video.')),
        );
      }
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      // Access the picked file path
      final filePath = pickedFile.files.single.path!;

      // Check file size (example: limit to 10MB)
      final fileSize = await File(filePath).length();
      if (fileSize > 10 * 1024 * 1024) {
        // Show error message for file size exceeding limit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File size exceeds the limit (10MB).')),
        );
        return;
      }

      // Upload file to storage
      final fileUrl = await ImageService().uploadImageToFirestore(
        XFile(filePath), // Create an XFile from the file path
        'chat_file_${generateUniqueId()}',
      );

      if (fileUrl != null) {
        // Send file URL in chat message
        final currentUserId = _authService.getCurrentUser()!.uid;
        final message = ChatMessage(
          id: '',
          senderId: currentUserId,
          chatId: widget.chat.id,
          content: '',
          fileUrl: fileUrl,
          timestamp: DateTime.now(),
          type: 'file', receiverId: '',
        );

        try {
          await ChatService().sendMessage(message);
        } catch (e) {
          // Show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending message: $e')),
          );
        }
      } else {
        // Show an error message for file upload failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading file.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name ?? 'Unnamed Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<
                List<ChatMessage>>( // Use StreamBuilder for real-time updates
              stream: ChatService().getMessagesForChat(widget.chat.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final messages = snapshot.data ?? [];
                  return ListView.builder(
                    reverse: true, // Display messages in reverse order
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageTile(message);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                        hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => _pickImage(context),
                ),
                IconButton(
                  icon: const Icon(Icons.video_camera_back),
                  onPressed: () => _pickVideo(context),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _pickFile(context),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    // TODO: Send message
                    final currentUserId = _authService.getCurrentUser()!.uid;
                    final message = ChatMessage(
                      id: '',
                      // Generate a unique ID
                      senderId: currentUserId,
                      chatId: widget.chat.id,
                      content: _messageController.text,
                      timestamp: DateTime.now(),
                      type: 'text',
                      receiverId: '', // Or other types like 'image' if you implement them
                    );

                    try {
                      await ChatService().sendMessage(message);
                      _messageController.clear(); // Clear the message field
                    } catch (e) {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error sending message: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(ChatMessage message) {
    final bool isMe = message.senderId == _authService.getCurrentUser()!.uid;
    InkWell(
        onTap: () {
          // Navigate to UserProfileScreen for the message sender
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(authUser: _getAuthUser(message.senderId)), // Assuming you have a way to get AuthUser by ID
            ),
          );
        },
    child: ListTile(
      title: message.type == 'text'
          ? Text(message.content) // Display text message
          : (message.type == 'image'
          ? Image.network(message.imageUrl!) // Display image
          : (message.type == 'video'
          ? _buildVideoPlayer(message.videoUrl!) // Display video player
          : _buildFileAttachment(message.fileUrl!))), // Display file attachment
      leading: isMe
          ? null
          : FutureBuilder<String>( // Use FutureBuilder to fetch avatar URL
        future: _getUserAvatarUrl(message.senderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(
              child: CircularProgressIndicator(), // Show loading indicator while fetching
            );
          } else if (snapshot.hasError) {
            return CircleAvatar(
              child: Icon(Icons.error), // Show error icon if fetching fails
            );
          } else {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!),
            );
          }
        },
      ),
      trailing: isMe
          ? CircleAvatar(
      backgroundImage: NetworkImage(_authService.getCurrentUser()!.photoURL ?? ''), // Use current user's avatar
    )
          : null,
    ))
    ;
  }
  Future<String> _getUserAvatarUrl(String userId) async {
    // TODO: Fetch user avatar URL from database or user object
    final user = await UserService().getUser(userId); // Assuming you have a getUser method in UserService
    return user.profileImageUrl;
  }
  Widget _buildVideoPlayer(String videoUrl) {
    final VideoPlayerController _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          _PlayPauseOverlay(controller: _controller),
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    );
  }
  Widget _buildFileAttachment(String fileUrl) {
    return ListTile(
      leading: const Icon(Icons.attach_file),
      title: Text(Uri
          .parse(fileUrl)
          .pathSegments
          .last), // Display file name
      onTap: () async {
        final result = await OpenFile.open(fileUrl);
        // Handle result (e.g., show error message if file cannot be opened)
      },
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}


