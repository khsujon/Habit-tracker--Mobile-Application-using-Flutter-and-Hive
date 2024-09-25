import 'package:flutter/material.dart';
import 'package:habit_tracker/widgets/habit_tile.dart';
import 'package:habit_tracker/widgets/my_alert_box.dart';
import 'package:habit_tracker/widgets/my_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //data structure for habitCompleted
  List todaysHabit = [
    //[habitName,habitCompleted]
    ["Morning Walk", false],
    ["Read Book", false],
    ["Pray", false],
  ];

  //checkBox tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabit[index][1] = value;
    });
  }

  //Habit name controller
  final TextEditingController _newHabitNameController = TextEditingController();

  //create a new habit
  void createNewHabit() {
    //show alert dialogue to add habit
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          hintText: 'Enter new habit',
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  //Save Habit
  void saveNewHabit() {
    //adding new habit to todays list
    setState(() {
      todaysHabit.add([_newHabitNameController.text, false]);
    });
    //clear the text field first
    _newHabitNameController.clear();

    //pop the dialog box
    Navigator.of(context).pop();
  }

  //cancel habit
  void cancelDialogBox() {
    //clear the text field first
    _newHabitNameController.clear();

    //pop the dialog box
    Navigator.of(context).pop();
  }

  //open edit habit
  void openEditHabit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          hintText: todaysHabit[index][0],
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  //Save existing habit with new name
  void saveExistingHabit(int index) {
    setState(() {
      todaysHabit[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  //delete Habit
  void deleteHabit(int index) {
    setState(() {
      todaysHabit.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: () => createNewHabit(),
      ),
      body: ListView.builder(
        itemCount: todaysHabit.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habitName: todaysHabit[index][0],
            isCompleted: todaysHabit[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            editTapped: (value) => openEditHabit(index),
            deleteTapped: (value) => deleteHabit(index),
          );
        },
      ),
    );
  }
}
