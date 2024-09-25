import 'package:habit_tracker/DateTime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//reference the box
final _myBox = Hive.box('Habit_DB');

//database class
class HabitDatabase {
  List todayHabitList = [];

  Map<DateTime, int> heatMapDataSet = {};

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

    //habit complete percent every day
    calculatePercentages();

    //load heat map

    loadHeatMap();
  }

  void calculatePercentages() {
    int completedCount = 0;

    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        completedCount++;
      }
    }

    String percent = todayHabitList.isEmpty
        ? "0.0"
        : (completedCount / todayHabitList.length).toStringAsFixed(1);

    //put the value int the database
    _myBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get('START_DATE'));

    //number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // Loop from start date to today and add each percentage to the dataset
// "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strength = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // Split the datetime up like below so it doesn't worry about hours/mins/secs etc.
      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
