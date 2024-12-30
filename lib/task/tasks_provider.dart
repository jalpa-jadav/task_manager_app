import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jalpa_practical/data/datasource/repository/task_repository_provider.dart';
import 'package:jalpa_practical/task/task_notifier.dart';
import 'package:jalpa_practical/task/task_state.dart';

final tasksProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});
