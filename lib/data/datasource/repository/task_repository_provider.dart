import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jalpa_practical/data/datasource/repository/task_repository.dart';
import 'package:jalpa_practical/data/datasource/repository/task_repository_impl.dart';
import 'package:jalpa_practical/data/datasource/task_datasource_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final datasource = ref.read(taskDatasourceProvider);
  return TaskRepositoryImpl(datasource);
});
