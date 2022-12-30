import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class TextFieldMiaged {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final TextFormField textFormField;

  TextFieldMiaged({
    required String label,
    Icon? icon,
    List<String? Function(String?)?>? validators,
    Iterable<Future<String?> Function(String?)>? asyncValidators,
    bool? disabled,
    String? value,
    bool? obscureText,
    bool? enableSuggestions,
    bool? autocorrect,
    void Function(String? value)? onChange,
    void Function(String? value)? onSave,
  }) {
    textFormField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: disabled == null ? true : !disabled,
      obscureText: obscureText ?? false,
      enableSuggestions: enableSuggestions ?? true,
      autocorrect: autocorrect ?? true,
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
        prefixIcon: icon,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSave,
      onChanged: onChange,
    );
    if (value != null) controller.text = value;
  }

  String? get value {
    return textFormField.controller?.text;
  }
}

class MoneyFieldMiaged extends TextFieldMiaged {

  @override
  final TextEditingController controller = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ' ');

  MoneyFieldMiaged({
    required super.label,
    super.icon,
    super.validators,
    super.disabled,
    super.value,
    super.obscureText,
    super.enableSuggestions,
    super.autocorrect,
    super.onChange,
    super.onSave,
  });
}