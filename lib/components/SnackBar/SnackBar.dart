import 'package:flutter/material.dart';


class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({super.key, required this.message});
  final String message;

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'undo', onPressed: () {}, ));
  }
}