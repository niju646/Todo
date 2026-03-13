import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final bool isbackbutton;
  final List<Widget> actions;
  final VoidCallback? onBackPressed;

  const CommonAppBar({
    super.key,
    required this.title,
    this.isbackbutton = true,
    this.actions = const [],
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            // ── Back button ──────────────────────────────────
            if (isbackbutton)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (onBackPressed != null) {
                      onBackPressed!();
                    } else {
                      context.pop();
                    }
                  },
                ),
              ),

            // ── Title ────────────────────────────────────────
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ── Actions ──────────────────────────────────────
            if (actions.isNotEmpty) ...[const SizedBox(width: 8), ...actions],
          ],
        ),
      ),
    );
  }
}

// ── Circle icon button ────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEF3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF1A1A2E)),
        ),
      ),
    );
  }
}
