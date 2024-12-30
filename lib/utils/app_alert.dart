import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jalpa_practical/data/datasource/model/task.dart';
import 'package:jalpa_practical/task/tasks_provider.dart';
import 'package:jalpa_practical/values/app_color.dart';
import 'package:jalpa_practical/values/app_style.dart';

@immutable
class AppAlerts {
  const AppAlerts._();

  static displaySnackbar(BuildContext context, String message) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyle.copyWith(
            color: isDarkMode ? Colors.white54 : AppColor.black,
          ),
        ),
        // backgroundColor: context.colorScheme.onSecondary,
      ),
    );
  }

  static Future<void> showAlertDeleteDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Task task,
  }) async {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget cancelButton = TextButton(
      child: const Text('NO'),
      onPressed: () => Navigator.pop(context),
    );
    Widget deleteButton = TextButton(
      onPressed: () async {
        await ref.read(tasksProvider.notifier).deleteTask(task).then(
          (value) {
            displaySnackbar(
              context,
              'Task deleted successfully',
            );
            Navigator.pop(context);
          },
        );
      },
      child: const Text('YES'),
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(
        'Delete contact?',
        style: alertTitleStyle.copyWith(
            color: isDarkMode ? Colors.white54 : AppColor.black),
      ),
      content: Text(
        'Are you sure you want to delete this contact?',
        style: textStyle.copyWith(
            color: isDarkMode ? Colors.white54 : AppColor.black),
      ),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
