import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({super.key, required this.onPress, required this.title});
  final VoidCallback onPress;
  final String title;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPress,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
