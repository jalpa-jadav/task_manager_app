import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jalpa_practical/task/tasks_provider.dart';
import 'package:jalpa_practical/theme/theme_provider.dart';
import 'package:jalpa_practical/ui/add_task_screen.dart';
import 'package:jalpa_practical/ui/task_details_screen.dart';
import 'package:jalpa_practical/utils/app_alert.dart';
import 'package:jalpa_practical/values/app_color.dart';
import 'package:jalpa_practical/values/app_style.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static HomeScreen builder(BuildContext context) => const HomeScreen();
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(tasksProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Filter tasks based on the search query
    final filteredTasks = _searchQuery.isEmpty
        ? taskState.tasks
        : taskState.tasks
            .where((task) =>
                task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          title: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              hintStyle: textStyle.copyWith(color: Colors.white60),
              border: InputBorder.none,
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
            ),
            style: textStyle.copyWith(color: Colors.white),
            cursorColor: Colors.white,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0).r,
              child: IconButton(
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ],
        ),
        body: filteredTasks.isEmpty
            ? Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? "No tasks yet. Add a new task!"
                      : "No tasks match your search.",
                  style: textStyle.copyWith(
                    fontSize: 16.sp,
                    color: themeMode == ThemeMode.light
                        ? AppColor.black
                        : AppColor.white,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10).r,
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  final textDecoration = task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8).r,
                    padding: const EdgeInsets.all(12).r,
                    decoration: BoxDecoration(
                      color: themeMode == ThemeMode.light
                          ? Colors.white
                          : AppColor.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: AppColor.primaryColor.withOpacity(0.7),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailsScreen(task: task),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: textStyle.copyWith(
                                        color: themeMode == ThemeMode.light
                                            ? AppColor.black
                                            : AppColor.white,
                                        decoration: textDecoration,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      task.description,
                                      style: textStyle.copyWith(
                                        color: themeMode == ThemeMode.light
                                            ? AppColor.black
                                            : AppColor.white,
                                        decoration: textDecoration,
                                        fontSize: 14.sp,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  ref
                                      .read(tasksProvider.notifier)
                                      .toggleTaskCompletion(task);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: task.isCompleted
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddTaskScreen(task: task),
                                        ),
                                      );
                                    },
                              icon: Icon(
                                Icons.edit_outlined,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : AppColor.primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await AppAlerts.showAlertDeleteDialog(
                                  context: context,
                                  ref: ref,
                                  task: task,
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: AppColor.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:jalpa_practical/main.dart';
// import 'package:jalpa_practical/task/tasks_provider.dart';
// import 'package:jalpa_practical/theme/theme_provider.dart';
// import 'package:jalpa_practical/ui/add_task_screen.dart';
// import 'package:jalpa_practical/ui/task_details_screen.dart';
// import 'package:jalpa_practical/utils/app_alert.dart';
// import 'package:jalpa_practical/values/app_color.dart';
// import 'package:jalpa_practical/values/app_style.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class HomeScreen extends ConsumerWidget {
//   static HomeScreen builder(BuildContext context) => const HomeScreen();
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final taskState = ref.watch(tasksProvider);
//     final themeMode = ref.watch(themeModeProvider);
//
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColor.primaryColor,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddTaskScreen()),
//           );
//         },
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 40,
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: AppColor.primaryColor,
//         centerTitle: true,
//         title: Text(
//           "Tasks",
//           style: appBarTitleStyle,
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0).r,
//             child: IconButton(
//               icon: Icon(
//                 themeMode == ThemeMode.light
//                     ? Icons.dark_mode
//                     : Icons.light_mode,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 ref.read(themeModeProvider.notifier).toggleTheme();
//               },
//             ),
//           ),
//         ],
//       ),
//       body: taskState.tasks.isEmpty
//           ? Center(
//               child: Text(
//                 "No tasks yet. Add a new task!",
//                 style: textStyle.copyWith(
//                   fontSize: 16.sp,
//                   color: themeMode == ThemeMode.light
//                       ? AppColor.black
//                       : AppColor.white,
//                 ),
//               ),
//             )
//           : ListView.builder(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10).r,
//               itemCount: taskState.tasks.length,
//               itemBuilder: (context, index) {
//                 final task = taskState.tasks[index];
//                 final textDecoration = task.isCompleted
//                     ? TextDecoration.lineThrough
//                     : TextDecoration.none;
//
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8).r,
//                   padding: const EdgeInsets.all(12).r,
//                   decoration: BoxDecoration(
//                     color: themeMode == ThemeMode.light
//                         ? Colors.white
//                         : AppColor.black,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                     border: Border.all(
//                       color: AppColor.primaryColor.withOpacity(0.7),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   TaskDetailsScreen(task: task),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Flexible(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     task.title,
//                                     style: textStyle.copyWith(
//                                       color: themeMode == ThemeMode.light
//                                           ? AppColor.black
//                                           : AppColor.white,
//                                       decoration: textDecoration,
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     task.description,
//                                     style: textStyle.copyWith(
//                                       color: themeMode == ThemeMode.light
//                                           ? AppColor.black
//                                           : AppColor.white,
//                                       decoration: textDecoration,
//                                       fontSize: 14.sp,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Checkbox(
//                               value: task.isCompleted,
//                               onChanged: (value) {
//                                 ref
//                                     .read(tasksProvider.notifier)
//                                     .toggleTaskCompletion(task);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton(
//                             onPressed: task.isCompleted
//                                 ? null
//                                 : () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             AddTaskScreen(task: task),
//                                       ),
//                                     );
//                                   },
//                             icon: Icon(
//                               Icons.edit_outlined,
//                               color: task.isCompleted
//                                   ? Colors.grey
//                                   : AppColor.primaryColor,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               await AppAlerts.showAlertDeleteDialog(
//                                 context: context,
//                                 ref: ref,
//                                 task: task,
//                               );
//                             },
//                             icon: const Icon(
//                               Icons.delete,
//                               color: AppColor.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
//
//   Future<void> showNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Task Reminder',
//       'You have tasks to complete!',
//       platformChannelSpecifics,
//     );
//   }
//
//   Future<void> scheduleNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     // Schedule the notification
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Scheduled Task Reminder',
//       'This is a scheduled notification!',
//       tz.TZDateTime.now(tz.local)
//           .add(const Duration(seconds: 5)), // Schedule for 5 seconds later
//       platformChannelSpecifics,
//       // androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode:
//           AndroidScheduleMode.exactAllowWhileIdle, // Add this parameter
//     );
//   }
// }
