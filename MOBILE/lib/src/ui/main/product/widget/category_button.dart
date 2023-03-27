import 'package:base_code/src/struct/app_color.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
   CategoryButton(
      {required this.text, this.buttonStatus = ButtonStatus.normal, this.onPressed, Key? key})
      : super(key: key);
  final String text;
  final ButtonStatus buttonStatus;
  Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final Color buttonColor = buttonStatus.getColor();
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
      style: OutlinedButton.styleFrom(
          backgroundColor: buttonStatus == ButtonStatus.selected
              ? AppColors.pinkLight
              : null,
          side: BorderSide(color: buttonColor),
          shape: const StadiumBorder(),
          primary: buttonColor),
    );
  }
}

enum ButtonStatus { disabled, selected, normal }

extension GetStyle on ButtonStatus {
  Color getColor() {
    switch (this) {
      case ButtonStatus.disabled:
        return AppColors.secondary;
      case ButtonStatus.selected:
        return AppColors.pinkDark;
      case ButtonStatus.normal:
        return AppColors.primay;
    }
  }
}
