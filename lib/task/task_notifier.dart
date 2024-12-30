import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jalpa_practical/data/datasource/model/task.dart';
import 'package:jalpa_practical/data/datasource/repository/task_repository.dart';
import 'package:jalpa_practical/task/task_state.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super(const TaskState.initial()) {
    getTasks();
  }

  Future<void> createTask(Task task) async {
    try {
      await _repository.addTask(task);
      getTasks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _repository.deleteTask(task);
      getTasks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: task.isCompleted);
      toggleTaskCompletion(updatedTask);
      await _repository.updateTask(updatedTask);
      // final isCompleted = !task.isCompleted;
      // final updatedTask = task.copyWith(isCompleted: isCompleted);
      // await _repository.updateTask(updatedTask);
      getTasks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getTasks() async {
    try {
      final tasks = await _repository.getAllTasks();
      state = state.copyWith(tasks: tasks);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void toggleTaskCompletion(Task task) {
    final updatedTasks = [...state.tasks];
    final index = updatedTasks.indexOf(task);
    if (index != -1) {
      updatedTasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      state = state.copyWith(tasks: updatedTasks);
    }
  }
}
