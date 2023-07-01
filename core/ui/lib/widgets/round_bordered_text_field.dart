import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

class RoundBorderedTextFIeld extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String)? onChange;
  const RoundBorderedTextFIeld({
    Key? key,
    required this.label,
    this.controller,
    required this.enabled,
    this.onChange,
  }) : super(key: key);

  @override
  State<RoundBorderedTextFIeld> createState() => _RoundBorderedTextFIeldState();
}

class _RoundBorderedTextFIeldState extends State<RoundBorderedTextFIeld> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
    _textEditingController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    if (widget.onChange != null) {
      widget.onChange!(_textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: _textEditingController,
      obscureText: false,
      decoration: _inputDecoration(),
      maxLines: null,
      onChanged: (value) {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      },
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: widget.label,
      disabledBorder: _fieldBorder(),
      enabledBorder: _fieldBorder(),
      focusedBorder: _fieldBorder(focused: true),
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: ColorConstants.primaryYellow),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
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
