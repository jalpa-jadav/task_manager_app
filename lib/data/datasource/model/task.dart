import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String priority;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });

  // Convert Task object to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      date,
      priority,
      isCompleted,
    ];
  }

  // Create a copy of Task with modified fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
