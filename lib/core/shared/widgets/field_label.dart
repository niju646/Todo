import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const FieldLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
