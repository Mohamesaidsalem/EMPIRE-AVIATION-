import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;

  CheckboxWidget(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}
