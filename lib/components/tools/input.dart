import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool? error;
  final String errorText;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;
  final String? initValue;
  final bool? isEnabled;

  CustomTextField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.initValue,
      this.keyboardType,
      this.inputFormatter,
      this.error,
      this.isEnabled = true,
      this.errorText = "Düzgün deyil"})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final focusNode = FocusNode();
  final controller = TextEditingController();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          controller.text.isEmpty &&
          widget.initValue != null) {
        setState(() {
          controller.text = widget.initValue!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      controller: widget.controller ?? controller,
      keyboardType: widget.keyboardType,
      focusNode: focusNode,
      inputFormatters:
          widget.inputFormatter != null ? [widget.inputFormatter!] : [],
      decoration: InputDecoration(
          errorText: widget.error != null ? widget.errorText : null,
          contentPadding: const EdgeInsets.all(20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
          hintText: widget.hintText,
          fillColor: Colors.grey[200]),
    );
  }
}
