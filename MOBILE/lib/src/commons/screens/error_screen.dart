import 'package:flutter/material.dart';
import 'package:base_code/src/utils/app_strings.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({this.message, Key? key}) : super(key: key);
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(message ?? AppStrings.anErrorHasOccurred),
        ),
      ),
    );
  }
}
