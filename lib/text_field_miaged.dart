import 'package:flutter/material.dart';

class TextFieldMiaged {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final TextFormField textFormField;

  TextFieldMiaged({
    required String label,
    Icon? icon,
    List<String? Function(String?)?>? validators,
    bool? disabled,
    String? value,
    bool? obscureText,
    bool? enableSuggestions,
    bool? autocorrect,
  }) {
    textFormField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: disabled == null ? true : !disabled,
      validator: (value) {
        if (validators == null) return null;
        for (var validator in validators) {
          var result = validator!(value);
          if (result is String) {
            return result;
          }
        }
      },
      decoration: InputDecoration(
        labelText: label,
        icon: icon,
        border: const OutlineInputBorder(),
      ),
    );
    if (value != null) controller.text = value;
  }

  String? get value {
    return textFormField.controller?.text;
  }
}