import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final bool isbackbutton;
  const CommonAppBar({
    super.key,
    required this.title,
    this.isbackbutton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          (isbackbutton)
              ? IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(Icons.arrow_back_ios, size: 20),
                )
              : SizedBox.shrink(),
          SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
