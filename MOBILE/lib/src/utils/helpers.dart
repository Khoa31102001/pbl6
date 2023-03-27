import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/extension/exception_ex.dart';
import 'package:base_code/src/utils/app_strings.dart';

Future<T?> showLoading<T extends Object?>(BuildContext context,
    {String? message}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 100.0,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Container(
                margin: const EdgeInsets.all(4.0),
                child: Text(message ?? AppStrings.loadingData),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<T?> showErrorDialog<T extends Object?>(
    BuildContext context, dynamic catchedError) {
  Exception error = Exception(catchedError);
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(AppStrings.error),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(AppStrings.error),
      content: Text(error.message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(AppStrings.confirm),
        ),
      ],
    ),
  );
}

Future<T?> showSuccessDialog<T extends Object?>(BuildContext context,
    [String message = AppStrings.success]) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(AppStrings.success),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(AppStrings.error),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(AppStrings.confirm),
        ),
      ],
    ),
  );
}
