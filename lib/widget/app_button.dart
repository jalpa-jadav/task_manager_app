import 'package:flutter/material.dart';
import 'package:jalpa_practical/values/app_color.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      required this.bgColor,
      required this.text,
      this.onPressed,
      this.height,
      this.width,
      this.radius,
      required this.fgColor,
      this.icon,
      this.style,
      this.padding});

  final Color? bgColor;
  final Color? fgColor;
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final double? radius;
  final IconData? icon;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text, style: TextStyle(color: AppColor.white)),
            const SizedBox(width: 5),
            Icon(widget.icon, color: AppColor.white)
          ],
        )),
      ),
    );
  }
}
