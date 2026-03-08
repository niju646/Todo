import 'package:flutter/material.dart';

class EditBottomSheet extends StatefulWidget {
  final String title;
  final String description;
  final Future<void> Function(String title, String description) onPressed;
  const EditBottomSheet({
    super.key,
    required this.onPressed,
    required this.title,
    required this.description,
  });

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  late final TextEditingController titleController;
  late final TextEditingController descController;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                "Edit Todo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// Title
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Title is required"
                    : null,
              ),

              const SizedBox(height: 16),

              /// Description
              TextFormField(
                controller: descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Description is required"
                    : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setState(() => isLoading = true);
                          await widget.onPressed(
                            titleController.text.trim(),
                            descController.text.trim(),
                          );

                          if (mounted) setState(() => isLoading = false);
                        },
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
                            key: ValueKey('loader'),
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Update Task",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showEditTodoSheet({
  required BuildContext context,
  required String title,
  required String description,
  required Future<void> Function(String title, String description) onPressed,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditBottomSheet(
      title: title,
      description: description,
      onPressed: onPressed,
    ),
  );
}
