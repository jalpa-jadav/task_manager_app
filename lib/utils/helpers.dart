import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jalpa_practical/providers/date_provider.dart';

@immutable
class Helpers {
  const Helpers._();

  static selectDate(BuildContext context, WidgetRef ref) async {
    final initialDate = ref.read(dateProvider);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2060),
    );

    if (pickedDate != null) {
      ref.read(dateProvider.notifier).state = pickedDate;
      debugPrint("ONLYDATE------>${pickedDate}");
    }

    return pickedDate;
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('MM/dd/yyyy'); // Change the format as needed
    return formatter.format(date);
  }
}
