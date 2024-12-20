import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String chatRoomId;

  MessageModel({
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.chatRoomId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      chatRoomId: json['chatRoomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'chatRoomId': chatRoomId,
    };
  }
} 