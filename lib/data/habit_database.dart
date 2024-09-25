import 'package:habit_tracker/DateTime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//reference the box
final _myBox = Hive.box('Habit_DB');

//database class
class HabitDatabase {
  List todayHabitList = [];

  //create initial default data
  void createDefaultData() {
    todayHabitList = [
      ["Salah", false],
      ["Workout", false],
    ];

    _myBox.put('START_DATE', todaysDateFormatted());
  }

  //load existing data
  void loadData() {
    //if its new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todayHabitList = _myBox.get('CURRENT_HABIT_LIST');
      //set all habit completed to false since its a new day
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[i][1] = false;
      }
    }
    //if its not a new day, load todays list
    else {
      todayHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  //update the database
  void updateDatabase() {
    //update todays entry
    _myBox.put(todaysDateFormatted(), todayHabitList);

    //update universal habit list in case it change(new habit, edit habit or delete habit)
    _myBox.put('CURRENT_HABIT_LIST', todayHabitList);
  }
}
