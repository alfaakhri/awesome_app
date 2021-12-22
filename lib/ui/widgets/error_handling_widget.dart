import 'package:flutter/material.dart';

class ErrorHandlingWidget extends StatelessWidget {
  final String message;
  final Function() onPressed;
  const ErrorHandlingWidget(
      {Key? key, required this.message, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Refresh"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade500),
          ),
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: themeData.textTheme.headline6?.copyWith(color: Colors.black),
        ),
      ],
    ));
  }
}
