import 'package:flutter/material.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    this.controller,
    this.placeholder,
    this.validator,
    this.disabled = true,
    this.isRequired = false,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
    this.initialValue,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.onChanged,
  });

  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final String? placeholder;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;
  final bool disabled;
  final bool isRequired;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? labelText;
  final void Function(String value)? onChanged;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final _controller = TextEditingController();
  bool isVisibleClear = false;

  @override
  void didUpdateWidget(covariant TextInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? .4 : 1,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null)
              Padding(
                padding: EdgeInsets.only(
                  left: widget.isRequired ? 8 : 16,
                  right: 16,
                  top: 12,
                  bottom: 4,
                ),
                child: Row(
                  children: [
                    if (widget.isRequired)
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFF3141),
                          fontSize: 15,
                          fontFamily: 'SimSun',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    Text(
                      widget.labelText ?? '',
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 15,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            TextFormField(
              validator: widget.validator,
              controller: _controller,
              readOnly: widget.readOnly,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              initialValue: widget.initialValue,
              minLines: widget.minLines, // Set this
              maxLines: widget.maxLines,
              onChanged: (value) {
                setState(() {
                  isVisibleClear =
                      _controller.text.isNotEmpty || _controller.text != "";
                });
                widget.onChanged?.call(value);
              },
              decoration: InputDecoration(
                hintText: widget.placeholder,
                enabled: !widget.disabled,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.suffixIcon ?? const SizedBox(),
                    if (isVisibleClear)
                      IconButton(
                        onPressed: () {
                          _controller.text = "";
                          setState(() {
                            isVisibleClear = _controller.text.isNotEmpty ||
                                _controller.text != "";
                          });
                        },
                        icon: const Icon(
                          CustomIcons.closecircle,
                          size: 20,
                          color: Color(0xffABABAB),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
