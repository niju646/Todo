import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? badgeCount;
  final String? badgeLabel;
  final TextEditingController? searchController;
  final String? searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchCleared;
  final String? searchHint;
  final Widget? bottomWidget;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeCount,
    this.badgeLabel,
    this.searchController,
    this.searchQuery,
    this.onSearchChanged,
    this.onSearchCleared,
    this.searchHint,
    this.bottomWidget,
  });

  bool get _hasSearch =>
      searchController != null &&
      onSearchChanged != null &&
      onSearchCleared != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // ── Decorative circles ──────────────────────────
          const Positioned(
            top: -40,
            right: -40,
            child: DecorCircle(size: 160, alpha: 7),
          ),
          const Positioned(
            top: 30,
            right: 30,
            child: DecorCircle(size: 80, alpha: 6),
          ),
          const Positioned(
            bottom: 40,
            left: -30,
            child: DecorCircle(size: 100, alpha: 5),
          ),

          // ── Content ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(160),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (subtitle != null) const SizedBox(height: 2),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),

                    // Badge
                    if (badgeCount != null && badgeCount! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withAlpha(28),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF69F0AE),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "$badgeCount ${badgeLabel ?? 'total'}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                // Search bar
                if (_hasSearch) ...[
                  const SizedBox(height: 20),
                  _SearchBar(
                    controller: searchController!,
                    searchQuery: searchQuery ?? '',
                    onChanged: onSearchChanged!,
                    onCleared: onSearchCleared!,
                    hint: searchHint ?? "Search...",
                  ),
                ],
                if (bottomWidget != null) ...[
                  const SizedBox(height: 16),
                  bottomWidget!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onCleared;
  final String hint;

  const _SearchBar({
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onCleared,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(22), width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withAlpha(90), fontSize: 14),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withAlpha(110),
            size: 20,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white.withAlpha(110),
                    size: 18,
                  ),
                  onPressed: onCleared,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

// ── Decor circle ──────────────────────────────────────────────────────────────

class DecorCircle extends StatelessWidget {
  final double size;
  final int alpha;

  const DecorCircle({super.key, required this.size, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(alpha),
      ),
    );
  }
}
