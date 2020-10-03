import 'package:flutter/material.dart';

showAlertPage(context, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
        );
      }
  );
}

