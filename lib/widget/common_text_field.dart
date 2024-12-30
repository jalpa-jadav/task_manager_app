import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jalpa_practical/values/app_color.dart';
import 'package:jalpa_practical/values/app_style.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.txt,
    required this.title,
    this.readOnly = false,
    this.onTap,
    this.maxLines,
    this.controller,
    this.suffixIcon,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.onChange,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.hintStyle,
  });

  final String txt;
  final String title;
  final TextStyle? hintStyle;
  final bool readOnly;
  final int? maxLines;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : AppColor.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // style: textStyle,
        ),
        5.verticalSpace,
        TextFormField(
          controller: controller,
          style: textStyle.copyWith(color: textColor),
          readOnly: readOnly,
          keyboardType: keyboardType,
          onChanged: onChange,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: txt,
            hintStyle: hintStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white54
                    : AppColor.black, // Dark theme white border
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.red
                    : AppColor.primaryColor, // Dark theme error color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.red
                    : AppColor.primaryColor, // Dark theme error color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white
                    : AppColor.primaryColor, // Dark theme focused border
              ),
            ),
          ),
        ),
      ],
    );
  }
}
