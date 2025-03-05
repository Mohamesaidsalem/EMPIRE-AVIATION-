import 'package:flutter/material.dart';

class TimeFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;

  TimeFieldWidget(
      {required this.label, required this.controller, this.onChanged});

  @override
  _TimeFieldWidgetState createState() => _TimeFieldWidgetState();
}

class _TimeFieldWidgetState extends State<TimeFieldWidget> {
  bool isValid = true;

  void _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      String formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      setState(() {
        widget.controller.text = formattedTime;
        isValid = true;
      });

      if (widget.onChanged != null) {
        widget.onChanged!(formattedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => _pickTime(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(Icons.access_time,
                color: isValid ? Colors.blue : Colors.red),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            widget.controller.text.isEmpty ? "HH:mm" : widget.controller.text,
            style: TextStyle(
                fontSize: 16, color: isValid ? Colors.black : Colors.red),
          ),
        ),
      ),
    );
  }
}
