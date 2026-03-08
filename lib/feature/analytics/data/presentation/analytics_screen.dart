import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/core/shared/widgets/summary_card.dart';
import 'package:to_do/core/utils/helper/helper.dart';
import 'package:to_do/feature/todo/data/provider/todo_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoProvider);
    final todos = state.todos;

    final total = todos.length;
    final completed = todos.where((t) => t.status == true).length;
    final pending = total - completed;
    final completionRate = total == 0 ? 0.0 : completed / total;

    int streak = 0;
    int maxStreak = 0;
    for (final t in todos) {
      if (t.status == true) {
        streak++;
        if (streak > maxStreak) maxStreak = streak;
      } else {
        streak = 0;
      }
    }

    final now = DateTime.now();
    final weekDays = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final dayTodos = todos.where((t) {
        final d = t.createdAt;
        return d != null &&
            d.year == day.year &&
            d.month == day.month &&
            d.day == day.day;
      }).toList();
      return _DayData(
        label: Helper().shortDay(day.weekday),
        total: dayTodos.length,
        completed: dayTodos.where((t) => t.status == true).length,
        isToday: i == 6,
      );
    });

    final maxBarValue = weekDays
        .map((d) => d.total)
        .fold(0, (a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalyticsHeader(
              completionRate: completionRate,
              completed: completed,
              total: total,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: "Total",
                          value: "$total",
                          icon: Icons.list_alt_rounded,
                          color: Color(0xFF5C6BC0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          label: "Completed",
                          value: "$completed",
                          icon: Icons.check_circle_outline_rounded,
                          color: const Color(0xFF43A047),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          label: "Pending",
                          value: "$pending",
                          icon: Icons.radio_button_unchecked_rounded,
                          color: const Color(0xFFFFB300),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: "Best Streak",
                          value: "$maxStreak",
                          icon: Icons.local_fire_department_rounded,
                          color: const Color(0xFFE53935),
                          suffix: "tasks",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SummaryCard(
                          label: "Completion Rate",
                          value:
                              "${(completionRate * 100).toStringAsFixed(1)}%",
                          icon: Icons.insights_rounded,
                          color: const Color(0xFF5C6BC0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const _SectionTitle(title: "This Week"),
                  SizedBox(height: 10),

                  _SectionCard(
                    child: Column(
                      children: [
                        // Bar chart
                        SizedBox(
                          height: 140,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: weekDays.map((day) {
                              return Expanded(
                                child: _WeekBar(
                                  data: day,
                                  maxValue: maxBarValue == 0 ? 1 : maxBarValue,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey.withAlpha(30), height: 1),
                        const SizedBox(height: 14),
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Legend(color: Color(0xFF5C6BC0), label: "Created"),
                            const SizedBox(width: 20),
                            _Legend(
                              color: const Color(0xFF69F0AE),
                              label: "Completed",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _SectionTitle(title: "Overview"),
                  SizedBox(height: 10),
                  _SectionCard(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: completionRate),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                                builder: (context, val, _) => CustomPaint(
                                  size: const Size(110, 110),
                                  painter: _DonutPainter(progress: val),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${(completionRate * 100).toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF5C6BC0),
                                    ),
                                  ),
                                  Text(
                                    "done",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          child: Column(
                            children: [
                              _BreakdownRow(
                                label: "Completed",
                                value: completed,
                                total: total,
                                color: const Color(0xFF43A047),
                              ),
                              const SizedBox(height: 12),
                              _BreakdownRow(
                                label: "Pending",
                                value: pending,
                                total: total,
                                color: const Color(0xFFFFB300),
                              ),
                              const SizedBox(height: 12),
                              _BreakdownRow(
                                label: "Total",
                                value: total,
                                total: total,
                                color: const Color(0xFF5C6BC0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Motivational footer ────────────────
                  _MotivationCard(completionRate: completionRate, total: total),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsHeader extends StatelessWidget {
  final double completionRate;
  final int completed;
  final int total;

  const _AnalyticsHeader({
    required this.completionRate,
    required this.completed,
    required this.total,
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
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analytics",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withAlpha(160),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your Progress",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 20),
                // Progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$completed of $total tasks completed",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withAlpha(140),
                      ),
                    ),
                    Text(
                      "${(completionRate * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: completionRate),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOut,
                    builder: (context, val, _) => Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: val,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF69F0AE), Color(0xFF00BFA5)],
                              ),
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
        ],
      ),
    );
  }
}

class _DayData {
  final String label;
  final int total;
  final int completed;
  final bool isToday;

  const _DayData({
    required this.label,
    required this.total,
    required this.completed,
    required this.isToday,
  });
}

class _WeekBar extends StatelessWidget {
  final _DayData data;
  final int maxValue;

  const _WeekBar({required this.data, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final totalRatio = data.total / maxValue;
    final completedRatio = data.total == 0 ? 0.0 : data.completed / maxValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Completed count
        if (data.completed > 0)
          Text(
            "${data.completed}",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        const SizedBox(height: 4),
        // Bar
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Total bar
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: totalRatio),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, val, _) => Container(
                    height: 90 * val,
                    decoration: BoxDecoration(
                      color: data.isToday
                          ? const Color.fromARGB(255, 88, 88, 192).withAlpha(30)
                          : Colors.grey.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Completed bar overlay
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: completedRatio),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (context, val, _) => Container(
                    height: 90 * val,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: data.isToday
                            ? [const Color(0xFF69F0AE), const Color(0xFF00BFA5)]
                            : [
                                const Color(0xFF69F0AE).withAlpha(180),
                                const Color(0xFF00BFA5).withAlpha(180),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Day label
        Text(
          data.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: data.isToday ? FontWeight.w700 : FontWeight.w500,
            color: data.isToday
                ? const Color(0xFF1A1A2E)
                : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double progress;

  _DonutPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -3.14159 / 2;
    final sweepAngle = 2 * 3.14159 * progress;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFF1A1A2E).withAlpha(12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF69F0AE)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.progress != progress;
}

class _MotivationCard extends StatelessWidget {
  final double completionRate;
  final int total;

  const _MotivationCard({required this.completionRate, required this.total});

  String get _message {
    if (total == 0) return "Add your first task and start your journey!";
    if (completionRate == 1.0) return "All tasks done! You're on fire!";
    if (completionRate >= 0.75) return "Almost there, keep pushing!";
    if (completionRate >= 0.5) return "Great progress, you're halfway!";
    if (completionRate >= 0.25) return "Good start, keep the momentum!";
    return "Every task completed is a step forward!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFFFD740),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withAlpha(220),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
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
            Text(
              "$value",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: ratio),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, val, _) => LinearProgressIndicator(
              value: val,
              minHeight: 4,
              backgroundColor: color.withAlpha(20),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF69F0AE).withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
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
