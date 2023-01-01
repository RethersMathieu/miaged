import 'package:flutter/material.dart';

import '../models/text_field_miaged.dart';

class MiagedTextField extends StatefulWidget {
  late final TextFieldMiaged textfield;

  MiagedTextField({
    super.key,
    required String label,
    Icon? icon,
    List<String? Function(String?)?>? validators,
    bool? disabled,
    String? value,
    bool? obscureText,
    bool? enableSuggestions,
    bool? autocorrect,
    void Function(String? value)? onChange,
    void Function(String? value)? onSave,
  }) {
    textfield = _initFIeld(label, icon, validators, disabled, value, obscureText, enableSuggestions, autocorrect, onChange, onSave);
  }

  TextFieldMiaged _initFIeld(
      String label,
      Icon? icon,
      List<String? Function(String?)?>? validators,
      bool? disabled,
      String? value,
      bool? obscureText,
      bool? enableSuggestions,
      bool? autocorrect,
      void Function(String? value)? onChange,
      void Function(String? value)? onSave,
  ) {
    return TextFieldMiaged(
        label: label,
        icon: icon,
        validators: validators,
        disabled: disabled,
        value: value,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        onChange: onChange,
        onSave: onSave,
    );
  }

  @override
  State<StatefulWidget> createState() => _MiagedTextFieldState();

}

class MiagedMoneyField extends MiagedTextField {

  MiagedMoneyField({
    super.key,
    required super.label,
    super.validators,
    super.disabled,
    super.value,
    super.obscureText,
    super.enableSuggestions,
    super.autocorrect,
    super.onChange,
    super.onSave,
  });

  @override
  TextFieldMiaged _initFIeld(
      String label,
      Icon? icon,
      List<String? Function(String? p1)?>? validators,
      bool? disabled,
      String? value,
      bool? obscureText,
      bool? enableSuggestions,
      bool? autocorrect,
      void Function(String? value)? onChange,
      void Function(String? value)? onSave,
  ) {
    return MoneyFieldMiaged(
      label: label,
      icon: const Icon(Icons.euro),
      validators: validators,
      disabled: disabled,
      value: value,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      onChange: onChange,
      onSave: onSave,
    );
  }
}

class _MiagedTextFieldState extends State<MiagedTextField> {

  @override
  Widget build(BuildContext context) {
    var textField = widget.textfield;
    return Padding(padding: const EdgeInsets.all(5.0), child: textField.textFormField);
  }

}