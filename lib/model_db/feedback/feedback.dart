import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../database_helper.dart';

part 'feedback.g.dart';

class Feedback {
  final String? id;
  final String content;
  final DateTime timestamp;
  final FeedbackStatus status;

  Feedback({
    this.id,
    required this.content,
    required this.timestamp,
    required this.status,
  });

  // Convert from database Map
  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'] as String?,
      content: map['content'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      status: FeedbackStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
    );
  }

  // Convert to database Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  // Create a copy of this feedback with some fields replaced
  Feedback copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    FeedbackStatus? status,
  }) {
    return Feedback(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

enum FeedbackStatus {
  inProgress,
  resolved,
  closed,
  pending
}
