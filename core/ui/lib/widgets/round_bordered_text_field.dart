import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

class RoundBorderedTextFIeld extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String) onChange;
  const RoundBorderedTextFIeld({
    super.key,
    required this.label,
    this.controller,
    required this.enabled,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
        labelText: label,
        disabledBorder: _fieldBorder(),
        enabledBorder: _fieldBorder(),
        focusedBorder: _fieldBorder(focused: true),
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: ColorConstants.primaryYellow),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
      ),
      maxLines: null,
      onChanged: (value) {
        onChange(value);
      },
    );
  }

  OutlineInputBorder _fieldBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color:
            (!focused) ? const Color(0xFFF1F4F8) : ColorConstants.primaryYellow,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
