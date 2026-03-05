import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isLarge;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool suffixIcon;
  const CommonTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isLarge = false,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon = false,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late bool _obscurePassword;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      maxLines: widget.isLarge ? 5 : 1,
      obscureText: widget.suffixIcon ? _obscurePassword : widget.obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: widget.suffixIcon
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
