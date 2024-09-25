import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:habit_tracker/widgets/habit_tile.dart';
import 'package:habit_tracker/widgets/my_alert_box.dart';
import 'package:habit_tracker/widgets/my_fab.dart';
import 'package:habit_tracker/widgets/summary_monthly.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //database instance
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_DB');

  @override
  void initState() {
    //if no current habit list,create default

    if (_myBox.get('CURRENT_HABIT_LIST') == null) {
      db.createDefaultData();
    }

    //already existing data
    else {
      db.loadData();
    }
    //updating the database
    db.updateDatabase();
    super.initState();
  }

  //checkBox tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value;
    });
    db.updateDatabase();
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
      db.todayHabitList.add([_newHabitNameController.text, false]);
    });
    //clear the text field first
    _newHabitNameController.clear();

    //pop the dialog box
    Navigator.of(context).pop();
    db.updateDatabase();
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
          hintText: db.todayHabitList[index][0],
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
      db.todayHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  //delete Habit
  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: () => createNewHabit(),
      ),
      body: ListView(
        children: [
          //Summary progress
          SummaryMonthly(
              datasets: db.heatMapDataSet, startDate: _myBox.get('START_DATE')),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todayHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.todayHabitList[index][0],
                isCompleted: db.todayHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                editTapped: (value) => openEditHabit(index),
                deleteTapped: (value) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
