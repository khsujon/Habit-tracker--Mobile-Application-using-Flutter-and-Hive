import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;
  const MyFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 5,
      backgroundColor: const Color.fromARGB(255, 17, 115, 17),
      onPressed: onPressed,
      child: Icon(
        Icons.add,
        size: 30,
        color: Colors.white,
      ),
      shape: CircleBorder(),
    );
  }
}
