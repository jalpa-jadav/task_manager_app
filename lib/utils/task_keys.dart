import 'package:flutter/foundation.dart' show immutable;

@immutable
class TaskKeys {
  const TaskKeys._();
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String date = 'date';
  static const String priority = 'priority';
  static const String isCompleted = 'isCompleted';
}
