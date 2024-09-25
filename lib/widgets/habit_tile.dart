import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitTile extends StatefulWidget {
  final String habitName;
  final bool isCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? editTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.isCompleted,
    required this.onChanged,
    required this.editTapped,
    required this.deleteTapped,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          //edit option
          SlidableAction(
            onPressed: widget.editTapped,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(12),
          ),

          //Delete option
          SlidableAction(
            onPressed: widget.deleteTapped,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.isCompleted ? Colors.green[300] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              //checkbox
              Checkbox(
                value: widget.isCompleted,
                onChanged: widget.onChanged,
              ),

              //Habit name
              Text(
                widget.habitName,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
