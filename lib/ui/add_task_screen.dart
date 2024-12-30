import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jalpa_practical/data/datasource/model/task.dart';
import 'package:jalpa_practical/providers/date_provider.dart'; // Assuming you have a theme provider
import 'package:jalpa_practical/task/tasks_provider.dart';
import 'package:jalpa_practical/theme/theme_provider.dart';
import 'package:jalpa_practical/utils/app_alert.dart';
import 'package:jalpa_practical/utils/helpers.dart';
import 'package:jalpa_practical/values/app_color.dart';
import 'package:jalpa_practical/values/app_style.dart';
import 'package:jalpa_practical/widget/app_button.dart';
import 'package:jalpa_practical/widget/common_text_field.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({
    super.key,
    this.task,
  });
  final Task? task;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  String dropdownValue = 'Low';
  final priorityList = ["Low", "Medium", "High"];
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task?.title ?? "";
      _descriptionController.text = widget.task?.description ?? "";
      _dateController.text = widget.task?.date ?? "";
      dropdownValue = widget.task?.priority ?? "Low";
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the theme mode from the provider
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.white,
          ),
        ),
        title: Text(
          widget.task == null ? 'Add New Task' : 'Edit Task',
          style: appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20).r,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.verticalSpace,
                CommonTextField(
                  title: "Title",
                  controller: _titleController,
                  hintStyle: hintStyle,
                  txt: 'Enter title',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
                15.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    final selectedDate = await Helpers.selectDate(context, ref);
                    if (selectedDate != null) {
                      final formattedDate = Helpers.formatDate(selectedDate);
                      _dateController.text = formattedDate;
                    }
                  },
                  child: AbsorbPointer(
                    child: CommonTextField(
                      txt: "Select date",
                      title: "Date",
                      hintStyle: hintStyle,
                      readOnly: true,
                      controller: _dateController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select a date'
                          : null,
                    ),
                  ),
                ),
                15.verticalSpace,
                CommonTextField(
                  txt: 'Enter description',
                  title: "Description",
                  maxLines: 3,
                  hintStyle: hintStyle,
                  controller: _descriptionController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                15.verticalSpace,
                Text(
                  "Priority",
                  style: textStyle.copyWith(
                    fontSize: 16.sp,
                    color: themeMode == ThemeMode.light
                        ? AppColor.black
                        : AppColor.white.withOpacity(0.8),
                  ),
                ),
                10.verticalSpace,
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeMode == ThemeMode.dark
                        ? theme.cardColor
                        : theme.cardColor, // Adjust background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeMode == ThemeMode.dark
                            ? AppColor.primaryColor
                            : AppColor
                                .primaryColor, // Border color for both themes
                      ),
                    ),
                  ),
                  value: dropdownValue,
                  items: priorityList.map((String priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority,
                          style: textStyle.copyWith(
                            color: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black, // Text color based on theme
                          )),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => dropdownValue = val!);
                  },
                  style: textStyle.copyWith(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black, // Text color based on theme
                  ),
                ),
                50.verticalSpace,
                AppButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.task == null ? _createTask() : _updateTask();
                    }
                  },
                  width: double.infinity,
                  height: 50.h,
                  bgColor: AppColor.primaryColor,
                  text: widget.task == null ? "Add Task" : "Update Task",
                  style: textStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  fgColor: Colors.white,
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createTask() async {
    final date = ref.watch(dateProvider);

    final task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: DateFormat.yMMMd().format(date),
      priority: dropdownValue,
      isCompleted: false,
    );

    await ref.read(tasksProvider.notifier).createTask(task).then((value) {
      AppAlerts.displaySnackbar(context, 'Task created successfully');
      Navigator.pop(context);
    });
  }

  void _updateTask() async {
    final updatedTask = widget.task!.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _dateController.text,
      priority: dropdownValue,
      isCompleted: false,
    );

    await ref.read(tasksProvider.notifier).updateTask(updatedTask);
    AppAlerts.displaySnackbar(context, 'Task updated successfully');
    Navigator.pop(context);
  }
}
