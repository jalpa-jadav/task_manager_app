import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jalpa_practical/data/datasource/model/task.dart';
import 'package:jalpa_practical/theme/theme_provider.dart';
import 'package:jalpa_practical/values/app_color.dart';
import 'package:jalpa_practical/values/app_style.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    final textDecoration = widget.task.isCompleted
        ? TextDecoration.lineThrough
        : TextDecoration.none;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.white,
          ),
        ),
        title: Text(
          'Task Details',
          style: appBarTitleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0).r,
        child: Container(
          decoration: BoxDecoration(
            color:
                themeMode == ThemeMode.light ? AppColor.white : AppColor.black,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: AppColor.primaryColor.withOpacity(0.7),
            ),
          ),
          padding: const EdgeInsets.all(16.0).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  widget.task.isCompleted
                      ? Icons.check_circle_outline
                      : Icons.pending_actions_outlined,
                  size: 50,
                  color: themeMode == ThemeMode.light
                      ? AppColor.primaryColor
                      : AppColor.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Task Title",
                style: textStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: themeMode == ThemeMode.light
                      ? AppColor.primaryColor
                      : AppColor.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.task.title,
                style: textStyle.copyWith(
                  fontSize: 16.sp,
                  color: themeMode == ThemeMode.light
                      ? AppColor.black
                      : AppColor.white,
                  decoration: textDecoration,
                ),
              ),
              20.verticalSpace,
              Text(
                "Description",
                style: textStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: themeMode == ThemeMode.light
                      ? AppColor.primaryColor
                      : AppColor.white,
                ),
              ),
              10.verticalSpace,
              Text(
                widget.task.description,
                style: textStyle.copyWith(
                  fontSize: 16.sp,
                  color: themeMode == ThemeMode.light
                      ? AppColor.black
                      : AppColor.white,
                  decoration: textDecoration,
                ),
              ),
              30.verticalSpace,
              Text(
                "Priority",
                style: textStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: themeMode == ThemeMode.light
                      ? AppColor.primaryColor
                      : AppColor.white,
                ),
              ),
              10.verticalSpace,
              Text(
                widget.task.priority,
                style: textStyle.copyWith(
                  fontSize: 16.sp,
                  color: themeMode == ThemeMode.light
                      ? AppColor.black
                      : AppColor.white,
                  decoration: textDecoration,
                ),
              ),
              30.verticalSpace,
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ).r,
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0).r,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Go Back",
                    style: textStyle.copyWith(
                      color: AppColor.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
