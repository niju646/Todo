import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final List categories;
  final bool isLoading;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.isLoading,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && categories.isEmpty) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedId,
          isExpanded: true,
          hint: Text(
            "Select a category",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade500,
          ),
          dropdownColor: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: categories.map((cat) {
            return DropdownMenuItem<int>(
              value: cat.id,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E).withAlpha(12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(cat.name ?? ""),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
