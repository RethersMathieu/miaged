import 'package:flutter/material.dart';

import '../models/validators.dart';

const _options = ['XL', 'L', 'M', 'S', 'XS'];

class DropdownSize extends StatefulWidget {
  final void Function(String?)? onChange;
  final void Function(String?)? onSave;

  const DropdownSize({super.key, this.onChange, this.onSave});

  @override
  State<StatefulWidget> createState() => _DropdownSizeState();
}

class _DropdownSizeState extends State<DropdownSize> {
  String sizeValue = _options[2];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DropdownButtonFormField(
        value: (() {
          if (widget.onChange != null) widget.onChange!(sizeValue);
          return sizeValue;
        })(),
        items: _options.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => sizeValue = value!);
          if (widget.onChange != null) widget.onChange!(value);
        },
        validator: Validators.required,
        onSaved: widget.onSave,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.accessibility),
            border: OutlineInputBorder()
        ),
      ),
    );
  }

}