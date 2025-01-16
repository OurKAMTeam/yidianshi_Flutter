import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../database_helper.dart';
import 'feedback.dart';

class FeedbackDatabase {
  static const String tableName = 'feedback';
  static const String columnId = 'id';
  static const String columnContent = 'content';
  static const String columnTimestamp = 'timestamp';
  static const String columnStatus = 'status';

  // Create table SQL command
  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnContent TEXT NOT NULL,
      $columnTimestamp TEXT NOT NULL,
      $columnStatus TEXT NOT NULL
    )
  ''';

  // Insert a new feedback
  static Future<String> insert(Feedback feedback) async {
    final db = await DatabaseHelper.instance.database;
    final id = feedback.id ?? const Uuid().v4();
    final feedbackMap = feedback.toMap()..['id'] = id;
    
    await db.insert(
      tableName,
      feedbackMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return id;
  }
}
