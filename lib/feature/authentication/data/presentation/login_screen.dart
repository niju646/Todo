import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routes/router_constants.dart';
import 'package:to_do/core/shared/common_text_field.dart';
import 'package:to_do/core/shared/custom_snackbar.dart';
import 'package:to_do/core/shared/widgets/field_label.dart';
import 'package:to_do/feature/authentication/data/provider/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _HeaderBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email field
                    FieldLabel(
                      icon: Icons.email_outlined,
                      label: "Email Address",
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      controller: _emailController,
                      labelText: "Email Address",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Email cannot be empty";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    FieldLabel(
                      icon: Icons.lock_outline_rounded,
                      label: "Password",
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      obscureText: true,
                      suffixIcon: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          await ref
                              .read(userProvider.notifier)
                              .login(email: email, password: password);

                          final updatedState = ref.read(userProvider);
                          if (!context.mounted) return;
                          if (updatedState.error == null) {
                            context.goNamed(RouteConstants.bottomNav);

                            CustomSnackbar.show(
                              context,
                              message: "Login successful",
                              type: SnackbarType.success,
                            );
                          } else {
                            CustomSnackbar.show(
                              context,
                              message:
                                  updatedState.error ?? "Something went wrong",
                              type: SnackbarType.failure,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A2E),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(
                            0xFF1A1A2E,
                          ).withAlpha(120),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: loginState.isLoading
                              ? const SizedBox(
                                  key: ValueKey('loading'),
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  key: ValueKey('label'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person_add_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.goNamed(RouteConstants.signup);
                        },
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              const TextSpan(text: "Dont have an account? "),
                              TextSpan(
                                text: "Signup",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(8),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(6),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Back to login",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Continue MyToDo and organising your day.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withAlpha(160),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
