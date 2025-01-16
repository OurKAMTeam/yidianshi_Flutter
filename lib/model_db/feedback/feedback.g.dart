// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

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

  // Get all feedback items
  static Future<List<Feedback>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Feedback.fromMap(maps[i]));
  }

  // Get feedback by id
  static Future<Feedback?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Feedback.fromMap(maps.first);
  }

  // Update feedback
  static Future<int> update(Feedback feedback) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      tableName,
      feedback.toMap(),
      where: '$columnId = ?',
      whereArgs: [feedback.id],
    );
  }

  // Delete feedback
  static Future<int> delete(String id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Get feedback by status
  static Future<List<Feedback>> getByStatus(FeedbackStatus status) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnStatus = ?',
      whereArgs: [status.toString().split('.').last],
    );
    return List.generate(maps.length, (i) => Feedback.fromMap(maps[i]));
  }

  // Update feedback status
  static Future<int> updateStatus(String id, FeedbackStatus status) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      tableName,
      {columnStatus: status.toString().split('.').last},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
