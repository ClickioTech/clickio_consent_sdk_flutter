import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Future<void> Function() onTap;

  const PrimaryButton({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(12, 20, 67, 1.0),
      ),
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}
