import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/shared/common_text_field.dart';
import 'package:to_do/feature/categories/data/provider/category_provider.dart';

class CreateCategoryBottomsheet extends ConsumerStatefulWidget {
  final String title;
  const CreateCategoryBottomsheet({super.key, required this.title});

  @override
  ConsumerState<CreateCategoryBottomsheet> createState() =>
      _CreateCategoryBottomsheetState();
}

class _CreateCategoryBottomsheetState
    extends ConsumerState<CreateCategoryBottomsheet> {
  final TextEditingController categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: formKey,
        child: Container(
          height: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 40),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.category_outlined, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          "Organise your tasks better",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CommonTextField(
                  labelText: "category name",
                  controller: categoryController,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      await ref
                          .read(categoryProvider.notifier)
                          .createCategory(
                            category: categoryController.text.trim(),
                          );
                      if (!context.mounted) return;
                      context.pop();
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
                      child: Text(
                        "Create Category",
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
      ),
    );
  }
}

void showCategoryBottomSheet({
  required BuildContext context,
  required String title,

  required VoidCallback onPressed,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CreateCategoryBottomsheet(title: title),
  );
}
