import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

const mainColor = 0xfff03034;
const mainColorHex = "#f03034";

bool? validationWithEmpty(String text, {int num = 3}) {
  if (text.length < num && text.isNotEmpty) return true;
  return null;
}

bool? validation(String text, {int num = 3}) {
  if (text.length < num) return true;
  return null;
}

bool? repeatPasswordValidation(String password, String repeatPass) {
  if (password != repeatPass && repeatPass.isNotEmpty) return true;
  return null;
}

void ShowTopSnackBar(BuildContext context, String message,
    {bool error = false, bool success = false, bool info = false}) {
  Widget snackBar;

  if (error) {
    snackBar = CustomSnackBar.error(message: message);
  } else if (success) {
    snackBar = CustomSnackBar.success(message: message);
  } else if (info) {
    snackBar = CustomSnackBar.info(message: message);
  } else {
    snackBar = CustomSnackBar.info(message: message);
  }

  showTopSnackBar(
    Overlay.of(context),
    Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 500,
          child: snackBar,
        ),
      ),
    ),
    displayDuration: const Duration(milliseconds: 1000),
  );
}
