import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routes/router_constants.dart';
import 'package:to_do/core/shared/custom_snackbar.dart';
import 'package:to_do/core/shared/widgets/show_dialogue_card.dart';
import 'package:to_do/core/theme/theme_provider.dart';
import 'package:to_do/feature/authentication/data/provider/user_provider.dart';
import 'package:to_do/feature/todo/data/provider/todo_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    // ref.read(userProvider.notifier).loadUserFromStorage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoProvider.notifier).totalTodo();
      ref.read(todoProvider.notifier).totalCompletedTodos();
      ref.read(todoProvider.notifier).pendingCount();
      ref.read(userProvider.notifier).loadUserFromStorage();
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    final userState = ref.watch(userProvider);
    final totalTodoState = ref.watch(todoProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top bar ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Avatar + info card ────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A1A2E).withAlpha(60),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(20),
                                border: Border.all(
                                  color: Colors.white.withAlpha(60),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => HapticFeedback.lightImpact(),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(30),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    size: 13,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Text(
                          userState.user?.name ?? "Sample",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userState.user?.email ?? "sample",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withAlpha(160),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Divider
                        Divider(color: Colors.white.withAlpha(30), height: 1),

                        const SizedBox(height: 20),

                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: "Total",
                              value: totalTodoState.totalItems.toString(),
                              color: Colors.white,
                            ),
                            _VerticalDivider(),
                            _StatItem(
                              label: "Done",
                              value: totalTodoState.totalCompletedTodos
                                  .toString(),
                              color: const Color(0xFF69F0AE),
                            ),
                            _VerticalDivider(),
                            _StatItem(
                              label: "Pending",
                              value: totalTodoState.pendingCount.toString(),
                              color: const Color(0xFFFFD740),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 12),

                  // ── Preferences ───────────────────────────────
                  const _SectionTitle(title: "Preferences"),
                  const SizedBox(height: 10),

                  _SectionCard(
                    child: Column(
                      children: [
                        _ToggleRow(
                          icon: Icons.dark_mode_outlined,
                          label: "Dark Mode",
                          subtitle: "Switch to dark theme",
                          value: ref.watch(themeProvider) == ThemeMode.dark,
                          onChanged: (val) {
                            ref.read(themeProvider.notifier).toggleTheme();
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Account actions ───────────────────────────
                  const _SectionTitle(title: "Account"),
                  const SizedBox(height: 10),

                  _SectionCard(
                    child: Column(
                      children: [
                        _ActionRow(
                          icon: Icons.logout_rounded,
                          label: "Log Out",
                          labelColor: const Color(0xFFE53935),
                          iconColor: const Color(0xFFE53935),
                          iconBg: const Color(0xFFFFEDED),
                          onTap: () => showDialogueCard(
                            context: context,
                            title: "Logout?",
                            description:
                                "You'll need to sign in again to access your tasks.",
                            buttonText: "Logout",
                            onTap: () async {
                              Navigator.pop(context); // close dialog first

                              await ref.read(userProvider.notifier).logout();

                              if (context.mounted) {
                                context.goNamed(RouteConstants.login);
                              }
                              if (!context.mounted) return;
                              CustomSnackbar.show(
                                context,
                                message: "Logout successful",
                                type: SnackbarType.success,
                              );
                            },
                          ),
                        ),
                      ],
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withAlpha(160),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.white.withAlpha(30));
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
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E).withAlpha(10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color labelColor;
  final Color iconColor;
  final Color iconBg;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor = const Color(0xFF1A1A2E),
    this.iconColor = const Color(0xFF1A1A2E),
    this.iconBg = const Color(0xFFEEEEF3),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
