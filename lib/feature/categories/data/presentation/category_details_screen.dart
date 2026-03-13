import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routes/router_constants.dart';
import 'package:to_do/core/shared/custom_snackbar.dart';
import 'package:to_do/core/shared/widgets/common_card.dart';
import 'package:to_do/core/shared/widgets/empty_screen.dart';
import 'package:to_do/feature/categories/model/category_model.dart';
import 'package:to_do/feature/todo/data/provider/todo_provider.dart';

class CategoryDetailsScreen extends ConsumerStatefulWidget {
  final Data category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryDetailsScreen> createState() =>
      _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends ConsumerState<CategoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(todoProvider.notifier)
          .fetchTodos(categoryId: widget.category.id ?? 0);
    });
  }

  Future<void> _refresh() async {
    HapticFeedback.mediumImpact();
    await ref
        .read(todoProvider.notifier)
        .fetchTodos(categoryId: widget.category.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    final todos = todoState.todos;
    final completed = todos.where((t) => t.status == true).length;
    final completionRate = todos.isEmpty ? 0.0 : completed / todos.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _CategoryHeader(
            category: widget.category,
            totalTasks: todos.length,
            completedTasks: completed,
            completionRate: completionRate,
          ),

          // ── Body ───────────────────────────────────────────
          Expanded(child: _buildBody(todoState, todos)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.pushNamed(
            RouteConstants.createtodo,
            extra: widget.category.id,
          );
        },
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          "New Task",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBody(dynamic todoState, List todos) {
    // Loading
    if (todoState.isLoading && todos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1A1A2E),
          strokeWidth: 2.5,
        ),
      );
    }

    // Empty
    if (todos.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        color: const Color(0xFF1A1A2E),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: EmptyStateCard(
                  title: "No Tasks Yet",
                  subtitle:
                      "Tap 'New Task' to add your first task in this category.",
                  icon: Icons.task_alt_outlined,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // List
    return RefreshIndicator(
      onRefresh: _refresh,
      color: const Color(0xFF1A1A2E),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return TweenAnimationBuilder<double>(
            key: ValueKey(todo.id),
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + index * 50),
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - value)),
                child: child,
              ),
            ),
            child: CommonCard(
              title: todo.title ?? "",
              description: todo.description ?? "",
              icon: Icons.delete_outline_rounded,
              isCompleted: todo.status ?? false,
              onDelete: () {
                HapticFeedback.mediumImpact();
                ref.read(todoProvider.notifier).deleteTodo(id: todo.id ?? 0);
                CustomSnackbar.show(
                  context,
                  message: "Deleted Successfully",
                  type: SnackbarType.success,
                );
              },
              onTap: () {
                HapticFeedback.lightImpact();
                context.pushNamed(
                  RouteConstants.todoDetailScreen,
                  extra: todo.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ── Category Header ───────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final Data category;
  final int totalTasks;
  final int completedTasks;
  final double completionRate;

  const _CategoryHeader({
    required this.category,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
  });

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
          // ── Decorative circles ───────────────────────────────
          Positioned(
            top: -40,
            right: -40,
            child: _DecorCircle(size: 160, alpha: 7),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: _DecorCircle(size: 80, alpha: 6),
          ),
          Positioned(
            bottom: 40,
            left: -30,
            child: _DecorCircle(size: 100, alpha: 5),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.pop();
                      },
                    ),
                    // Task count badge
                    if (totalTasks > 0)
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
                              "$totalTasks tasks",
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

                const SizedBox(height: 16),

                // ── Category icon + name ───────────────────────
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withAlpha(30),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.category_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name ?? "Unnamed",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ── Progress section ───────────────────────────
                if (totalTasks > 0) ...[
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _StatPill(
                        label: "Done",
                        value: "$completedTasks",
                        color: const Color(0xFF69F0AE),
                      ),
                      const SizedBox(width: 10),
                      _StatPill(
                        label: "Pending",
                        value: "${totalTasks - completedTasks}",
                        color: const Color(0xFFFFD740),
                      ),
                      const Spacer(),
                      Text(
                        "${(completionRate * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "done",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(140),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: completionRate),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOut,
                      builder: (context, val, _) => Stack(
                        children: [
                          Container(
                            height: 7,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: val,
                            child: Container(
                              height: 7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF69F0AE),
                                    Color(0xFF00BFA5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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
            color: Colors.white.withAlpha(18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withAlpha(30), width: 1),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color.withAlpha(200)),
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final int alpha;

  const _DecorCircle({required this.size, required this.alpha});

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
