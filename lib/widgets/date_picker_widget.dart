import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;

  DatePickerWidget(
      {required this.label,
      required this.controller,
      required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            onDateSelected(pickedDate);
            controller.text = "${pickedDate.toLocal()}"
                .split(' ')[0]; // ✅ تحديث القيمة في الحقل
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
          ),
          child: Text(
            controller.text.isEmpty
                ? "Select Date"
                : controller.text, // ✅ عرض القيمة الصحيحة
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
