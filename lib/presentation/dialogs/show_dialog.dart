import 'package:flutter/material.dart';
import 'error_dialog.dart';

void showErrorDialog(
  BuildContext context, {
  required String error,
}) {
  showDialog(
    context: context,
    builder: (_) => ErrorDialog(error),
  );
}
