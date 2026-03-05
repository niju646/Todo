import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const FieldLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF1A1A2E)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
