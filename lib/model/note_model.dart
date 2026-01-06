import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      userId: data['user_id'] ?? '',
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(updatedAt);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(updatedAt);
    } else {
      return DateFormat('MMM d, yyyy').format(updatedAt);
    }
  }
}