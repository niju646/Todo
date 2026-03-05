import 'package:flutter/material.dart';

class EmptyStateCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<EmptyStateCard> createState() => _EmptyStateCardState();
}

class _EmptyStateCardState extends State<EmptyStateCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A2E).withAlpha(6),
              ),
            ),
            // Inner circle
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A2E).withAlpha(10),
              ),
            ),
            // Icon
            Icon(
              widget.icon,
              size: 32,
              color: const Color(0xFF1A1A2E).withAlpha(100),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Title ───────────────────────────────────────
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 6),

        // ── Subtitle ─────────────────────────────────────
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            height: 1.5,
          ),
        ),

        // ── Action button ────────────────────────────────
        if (widget.actionLabel != null && widget.onAction != null) ...[
          const SizedBox(height: 24),
          GestureDetector(
            onTap: widget.onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A1A2E).withAlpha(40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    widget.actionLabel!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
