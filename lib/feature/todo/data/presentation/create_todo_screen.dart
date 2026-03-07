import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:to_do/core/shared/common_app_bar.dart';
import 'package:to_do/core/shared/common_text_field.dart';
import 'package:to_do/core/shared/custom_snackbar.dart';
import 'package:to_do/core/utils/custom_datepicker.dart';
import 'package:to_do/feature/todo/data/provider/todo_provider.dart';

class CreateTodoScreen extends ConsumerStatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  ConsumerState<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends ConsumerState<CreateTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.read(todoProvider.notifier);
  }

  Future<void> _handleCreate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(todoProvider.notifier)
        .createTodo(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: "ToDo created successfully!",
      type: SnackbarType.success,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final createTodoState = ref.watch(todoProvider);
    final isLoading = createTodoState.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: 30),
          // App bar
          CommonAppBar(title: "Create ToDo"),

          // Scrollable form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Header section
                    Text(
                      "What's on your mind?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Fill in the details below to add a new task.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Form card
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).cardColor.withAlpha(10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel(
                            label: "Title",
                            icon: Icons.title_rounded,
                          ),
                          const SizedBox(height: 8),
                          CommonTextField(
                            labelText: "Enter title",
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Title cannot be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: CustomDatePicker(
                              label: "Deadline*",
                              dateController: _dateController,
                              onDateSelected: (selectedDate) {
                                _dateController.text = DateFormat(
                                  'dd/MM/yyyy',
                                ).format(selectedDate);
                              },
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _FieldLabel(
                            label: "Description",
                            icon: Icons.notes_rounded,
                          ),
                          const SizedBox(height: 8),
                          CommonTextField(
                            labelText: "Add more details (optional)",
                            controller: _descriptionController,
                            isLarge: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleCreate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A2E),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(
                            0xFF1A1A2E,
                          ).withAlpha(120),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isLoading
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
                                    Icon(Icons.add_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "Create Task",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
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

class _FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FieldLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
