import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/utils/format_date.dart';
import 'package:to_do/feature/todo/data/provider/todo_provider.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  final int id;
  const TodoDetailScreen({super.key, required this.id});

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  Future<void> refreshData() async {
    if (!mounted) return;
    await Future.wait([
      ref.read(todoProvider.notifier).getTodoById(id: widget.id),
    ]);
    if (!mounted) return; // widget may have been disposed during the await
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    final todo = todoState.todos.firstWhere((todo) => todo.id == widget.id);
    final bool isCompleted = todo.status ?? false;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: RefreshIndicator(
              onRefresh: refreshData,
              child: Column(
                children: [
                  // ── Top bar ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.pop();
                          },
                        ),
                        const Spacer(),
                        _CircleIconButton(
                          icon: Icons.delete_outline_rounded,
                          onTap: () {},
                          color: const Color(0xFFFFEDED),
                          iconColor: const Color(0xFFE53935),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Status chip ────────────────────────
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _StatusChip(
                              key: ValueKey(isCompleted),
                              isCompleted: isCompleted,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Title ──────────────────────────────
                          Text(
                            todo.title ?? "Untitled Task",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              letterSpacing: 0.2,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: isCompleted
                                  ? Colors.green.shade600
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                              decorationThickness: 2,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Meta info row ──────────────────────
                          Row(
                            children: [
                              _MetaChip(
                                icon: Icons.calendar_today_rounded,
                                label: formatDate(DateTime.now()),
                              ),
                              const SizedBox(width: 10),
                              _MetaChip(
                                icon: Icons.access_time_rounded,
                                label: formatTime(DateTime.now()),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Description card ───────────────────
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color
                                            ?.withAlpha(12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.notes_rounded,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Description",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  todo.description ??
                                      "No description provided.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.7,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Toggle complete button ─────────────
                          GestureDetector(
                            onTap: () async {
                              await ref
                                  .read(todoProvider.notifier)
                                  .updateStatus(
                                    id: widget.id,
                                    status: !isCompleted,
                                  );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFF1A1A2E),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isCompleted
                                                ? Colors.green
                                                : Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge?.color)!
                                            .withAlpha(40),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      isCompleted
                                          ? Icons.check_circle_rounded
                                          : Icons.check_circle_outline_rounded,
                                      key: ValueKey(isCompleted),
                                      color: isCompleted
                                          ? Colors.green.shade600
                                          : Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      isCompleted
                                          ? "Completed"
                                          : "Mark as Complete",
                                      key: ValueKey(isCompleted),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isCompleted
                                            ? Colors.green.shade600
                                            : Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFFEEEEF3),
    this.iconColor = const Color(0xFF1A1A2E),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isCompleted;

  const _StatusChip({super.key, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? Color(0xFFE8F5E9) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.shade500
                  : Colors.orange.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isCompleted ? "Completed" : "In Progress",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? Colors.green.shade700
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
