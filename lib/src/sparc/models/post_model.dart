// Post model (converted from your TypeScript interface)
import 'package:flutter/material.dart';

class SparcPost {
  final String author;
  final String id; // Assuming id will always be a string
  final String content;
  final String title;
  final String description;
  final String question;
  final String docRef;
  final String userId;
  final String? topicId;
  final String createdAt;
  final int timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final int upvotes;
  final String? userName;
  final String? imageUrl;
  final int downvotes;
  final String? parentId;
  final String? photoURL;
  final String? postId;
  final List<dynamic>? questions;
  final List<dynamic>? answers; // Replace 'any' with 'dynamic'
  final String? bestAnswerId;
  final List<String>? relatedTags;
  final int? views;
  final int? clicks;
  final int? comments;
  final int? timeSpent;
  final int? maxDepth;
  final int? score;

  SparcPost({
    required this.author,
    required this.id,
    required this.content,
    required this.title,
    required this.description,
    required this.question,
    required this.docRef,
    required this.userId,
    this.topicId,
    required this.createdAt,
    required this.timestamp,
    required this.upvotes,
    this.userName,
    this.imageUrl,
    required this.downvotes,
    this.parentId,
    this.photoURL,
    this.postId,
    this.questions,
    this.answers,
    this.bestAnswerId,
    this.relatedTags,
    this.views,
    this.clicks,
    this.comments,
    this.timeSpent,
    this.maxDepth,
    this.score,
  });

  // Factory constructor to create a SparcPost from JSON
  factory SparcPost.fromJson(Map<String, dynamic> json) {
    return SparcPost(
      author: json['author'],
      id: json['id'].toString(),
      content: json['content'],
      title: json['title'],
      description: json['description'],
      question: json['question'],
      docRef: json['docRef'],
      userId: json['userId'],
      topicId: json['topicId'],
      createdAt: json['createdAt'],
      timestamp: json['timestamp'],
      upvotes: json['upvotes'],
      userName: json['userName'],
      imageUrl: json['imageUrl'],
      downvotes: json['downvotes'],
      parentId: json['parentId'],
      photoURL: json['photoURL'],
      postId: json['postId']?.toString(),
      questions: json['questions'],
      answers: json['answers'],
      bestAnswerId: json['bestAnswerId'],
      relatedTags: json['relatedTags']?.cast<String>(),
      views: json['views'],
      clicks: json['clicks'],
      comments: json['comments'],
      timeSpent: json['timeSpent'],
      maxDepth: json['maxDepth'],
      score: json['score'],
    );
  }
}

// SparcAnswer model
/*
class SparcAnswer {
  final String id;
  final String content;
  final String title;
  final String? description;
  final String? displayName;
  final String docRef;
  final String userId;
  final String userName;
  final String? questionId;
  final String? topicId;
  final String? parentId;
  final String? postId;
  final String? photoURL;
  final String createdAt;
  final int timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final int upvotes;
  final int downvotes;
  final int? views;
  final int? clicks;
  final int? comments;
  final int? timeSpent;
  final int? maxDepth;
  final int? score;

  SparcAnswer({
    required this.id,
    required this.content,
    required this.title,
    this.description,
    this.displayName,
    required this.docRef,
    required this.userId,
    required this.userName,
    this.questionId,
    this.topicId,
    this.parentId,
    this.postId,
    this.photoURL,
    required this.createdAt,
    required this.timestamp,
    required this.upvotes,
    required this.downvotes,
    this.views,
    this.clicks,
    this.comments,
    this.timeSpent,
    this.maxDepth,
    this.score,
  });

  // Factory constructor to create a SparcAnswer from JSON
  factory SparcAnswer.fromJson(Map<String, dynamic> json) {
    return SparcAnswer(
      // ... (map the JSON fields to the corresponding properties)
      timestamp: json['timestamp'], id: '', // You might need to adjust this based on your API response
    );
  }
}
*/

// SparcTopic model
class SparcTopic {
  final String author;
  final List<String>? administrator;
  final String id; // Assuming id will always be a string
  final String userId;
  final String description;
  final int? downvotes;
  final String? imageURl;
  final String? photoURL;
  final String title;
  final String? docRef;
  final String? parentId;
  final String? postId;
  final TopicStatus? status;
  final List<String>? questions;
  final String createdAt;
  final int timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final int? upvotes;
  final int? clicks;
  final int? shares;
  final int? comments;
  final int? timeSpent;
  final int? score;
  final int? followersCount;
  final List<String>? relatedTags;
  final int? maxDepth;

  SparcTopic({
    required this.author,
    this.administrator,
    required this.id,
    required this.userId,
    required this.description,
    this.downvotes,
    this.imageURl,
    this.photoURL,
    required this.title,
    this.docRef,
    this.parentId,
    this.postId,
    this.status,
    this.questions,
    required this.createdAt,
    required this.timestamp,
    this.upvotes,
    this.clicks,
    this.shares,
    this.comments,
    this.timeSpent,
    this.score,
    this.followersCount,
    this.relatedTags,
    this.maxDepth,
  });

  ///Factory constructor to create a SparcTopic from JSON
  factory SparcTopic.fromJson(Map<String, dynamic> json) {
    return SparcTopic(
      author: json['author'],
      administrator: json['administrator']?.cast<String>(),
      id: json['id'].toString(),
      userId: json['userId'],
      description: json['description'],
      downvotes: json['downvotes'],
      imageURl: json['imageURl'],
      photoURL: json['photoURL'],
      title: json['title'],
      docRef: json['docRef'],
      parentId: json['parentId'],
      postId: json['postId']?.toString(),
      status: _topicStatusFromString(json['status']),
      questions: json['questions']?.cast<String>(),
      createdAt: json['createdAt'],
      timestamp: json['timestamp'], // You might need to adjust this based on your API response
      upvotes: json['upvotes'],
      clicks: json['clicks'],
      shares: json['shares'],
      comments: json['comments'],
      timeSpent: json['timeSpent'],
      score: json['score'],
      followersCount: json['followersCount'],
      relatedTags: json['relatedTags']?.cast<String>(),
      maxDepth: json['maxDepth'],
    );
  }

  // Helper function to convert string to TopicStatus enum
  static TopicStatus? _topicStatusFromString(String? statusString) {
    if (statusString == null) return null;
    return TopicStatus.values.firstWhere(
          (e) => e.toString().split('.').last == statusString,
      orElse: () => TopicStatus.Pending, // Default to Pending if not found
    );
  }
}

// SparcAnswer model
class SparcAnswer {
  final String id;
  final String content;
  final String title;
  final String? description;
  final String? displayName;
  final String docRef;
  final String userId;
  final String userName;
  final String? questionId;
  final String? topicId;
  final String? parentId;
  final String? postId;
  final String? photoURL;
  final String createdAt;
  final int timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final int upvotes;
  final int downvotes;
  final int? views;
  final int? clicks;
  final int? comments;
  final int? timeSpent;
  final int? maxDepth;
  final int? score;

  SparcAnswer({
    required this.id,
    required this.content,
    required this.title,
    this.description,
    this.displayName,
    required this.docRef,
    required this.userId,
    required this.userName,
    this.questionId,
    this.topicId,
    this.parentId,
    this.postId,
    this.photoURL,
    required this.createdAt,
    required this.timestamp,
    required this.upvotes,
    required this.downvotes,
    this.views,
    this.clicks,
    this.comments,
    this.timeSpent,
    this.maxDepth,
    this.score,
  });

  // Factory constructor to create a SparcAnswer from JSON
  factory SparcAnswer.fromJson(Map<String, dynamic> json) {
    return SparcAnswer(
      id: json['id'].toString(),
      content: json['content'],
      title: json['title'],
      description: json['description'],
      displayName: json['displayName'],
      docRef: json['docRef'],
      userId: json['userId'],
      userName: json['userName'],
      questionId: json['questionId'],
      topicId: json['topicId'],
      parentId: json['parentId'],
      postId: json['postId']?.toString(),
      photoURL: json['photoURL'],
      createdAt: json['createdAt'],
      timestamp: json['timestamp'], // You might need to adjust this based on your API response
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      views: json['views'],
      clicks: json['clicks'],
      comments: json['comments'],
      timeSpent: json['timeSpent'],
      maxDepth: json['maxDepth'],
      score: json['score'],
    );
  }
}

// SparkComment model
class SparkComment {
  final bool active;
  final int depth;
  final String id;
  final String content;
  final String? photoURL;
  final String? parentCommentId;
  final String docRef;
  final String userId;
  final String postId;
  final String userName;
  final String createdAt;
  final int timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final String? topicId;
  final bool masterComment;
  final int? upvotes;
  final int? downvotes;
  final int? views;
  final int? clicks;
  final int? shares;
  final int? comments;
  final int? timeSpent;
  final String? parentId;
  final List<SparkReply>? replies;
  final int? maxDepth;
  final int? score;

  SparkComment({
    required this.active,
    required this.depth,
    required this.id,
    required this.content,
    this.photoURL,
    this.parentCommentId,
    required this.docRef,
    required this.userId,
    required this.postId,
    required this.userName,
    required this.createdAt,
    required this.timestamp,
    this.topicId,
    required this.masterComment,
    this.upvotes,
    this.downvotes,
    this.views,
    this.clicks,
    this.shares,
    this.comments,
    this.timeSpent,
    this.parentId,
    this.replies,
    this.maxDepth,
    this.score,
  });

  // Factory constructor to create a SparkComment from JSON
  factory SparkComment.fromJson(Map<String, dynamic> json) {
    return SparkComment(
      active: json['active'],
      depth: json['depth'],
      id: json['id'],
      content: json['content'],
      photoURL: json['photoURL'],
      parentCommentId: json['parentCommentId'],
      docRef: json['docRef'],
      userId: json['userId'],
      postId: json['postId'],
      userName: json['userName'],
      createdAt: json['createdAt'],
      timestamp: json['timestamp'], // You might need to adjust this based on your API response
      topicId: json['topicId'],
      masterComment: json['masterComment'],
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      views: json['views'],
      clicks: json['clicks'],
      shares: json['shares'],
      comments: json['comments'],
      timeSpent: json['timeSpent'],
      parentId: json['parentId'],
      replies: (json['replies'] as List?)
          ?.map((replyJson) => SparkReply.fromJson(replyJson))
          .toList(),
      maxDepth: json['maxDepth'],
      score: json['score'],
    );
  }
}

// SparkReply model
class SparkReply {
  final int depth;
  final String id;
  final String content;
  final String originalPostId;
  final String parentCommentId;
  final String userId;
  final String? parentId;
  final String postId; // Assuming postId will always be a string
  final String userName;
  final String displayName;
  final String createdAt; // Assuming createdAt will be a string representation of a date
  final int timestamp; // Assuming timestamp will be a number (seconds since epoch)
  final int? upvotes;
  final int? downvotes;
  final int? views;
  final int? clicks;
  final int? comments;
  final int? timeSpent;
  final List<SparkReply>? responses;
  final int? maxDepth;
  final int? score;

  SparkReply({
    required this.depth,
    required this.id,
    required this.content,
    required this.originalPostId,
    required this.parentCommentId,
    required this.userId,
    this.parentId,
    required this.postId,
    required this.userName,
    required this.displayName,
    required this.createdAt,
    required this.timestamp,
    this.upvotes,
    this.downvotes,
    this.views,
    this.clicks,
    this.comments,
    this.timeSpent,
    this.responses,
    this.maxDepth,
    this.score,
  });

  // Factory constructor to create a SparkReply from JSON
  factory SparkReply.fromJson(Map<String, dynamic> json) {
    return SparkReply(
      depth: json['depth'],
      id: json['id'],
      content: json['content'],
      originalPostId: json['originalPostId'],
      parentCommentId: json['parentCommentId'],
      userId: json['userId'],
      parentId: json['parentId'],
      postId: json['postId'].toString(),
      userName: json['userName'],
      displayName: json['displayName'],
      createdAt: json['createdAt'].toString(), // You might need to adjust this based on your API response
      timestamp: json['timestamp'], // You might need to adjust this based on your API response
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      views: json['views'],
      clicks: json['clicks'],
      comments: json['comments'],
      timeSpent: json['timeSpent'],
      responses: (json['responses'] as List?)
          ?.map((replyJson) => SparkReply.fromJson(replyJson))
          .toList(),
      maxDepth: json['maxDepth'],
      score: json['score'],
    );
  }
}

// TopicStatus enum
enum TopicStatus {
  Pending,
  Approved,
  Rejected,
}

// Question model
class Question {
  final int upvotes;
  final int downvotes;

  Question({required this.upvotes, required this.downvotes});

  // Factory constructor to create a Question from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
    );
  }
}

// Vote model
class Vote {
  final String? userId;
  final String entityId; // Assuming entityId will always be a string
  final String entityType;
  final String voteType;

  Vote({
    this.userId,
    required this.entityId,
    required this.entityType,
    required this.voteType,
  });

  // Factory constructor to create a Vote from JSON
  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      userId: json['userId'],
      entityId: json['entityId'].toString(),
      entityType: json['entityType'],
      voteType: json['voteType'],
    );
  }
}