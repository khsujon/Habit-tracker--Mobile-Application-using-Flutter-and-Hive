import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const MyAlertBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
      ),
      actions: [
        //cancel Button
        MaterialButton(
          onPressed: onCancel,
          color: Colors.black,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),

        //save button
        MaterialButton(
          onPressed: onSave,
          color: Colors.black,
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
