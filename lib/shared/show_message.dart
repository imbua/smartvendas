import 'package:flutter/material.dart';

void showMessage(String msg, BuildContext ctx) {
  SnackBar snackBar = SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 2),
    // action: SnackBarAction(
    // label: 'Undo',
    // onPressed: () {
    // Some code to undo the change.
    // },
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
}
