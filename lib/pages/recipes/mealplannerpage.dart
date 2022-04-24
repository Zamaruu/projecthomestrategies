import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/basiccard.dart';
import 'package:table_calendar/table_calendar.dart';

List<PlannendMealModel> plannedMeals = <PlannendMealModel>[
  PlannendMealModel(
    0,
    "Maxi",
    DateTime.now(),
    DateTime.now().add(const Duration(hours: 1)),
    "Suppe",
    Colors.green,
  ),
  PlannendMealModel(
    1,
    "Selli",
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 1, hours: 1)),
    "Hackbraten",
    Colors.red,
  ),
  PlannendMealModel(
    2,
    "Selli",
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 3, hours: 1)),
    "Bauerntopf",
    Colors.blue,
  ),
  PlannendMealModel(
    3,
    "Maxi",
    DateTime.now().add(const Duration(days: 4)),
    DateTime.now().add(const Duration(days: 6, hours: 1)),
    "Salat",
    Colors.yellow,
  ),
];

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: MealPlannerCalendar(),
    );
  }
}

class MealPlannerCalendar extends StatefulWidget {
  const MealPlannerCalendar({Key? key}) : super(key: key);

  @override
  State<MealPlannerCalendar> createState() => _MealPlannerCalendarState();
}

class _MealPlannerCalendarState extends State<MealPlannerCalendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<PlannendMealModel> _getEventsForDay(DateTime day) {
    print(day);
    var meals = plannedMeals
        .where((meal) =>
            Global.isDateInRange(
                meal.startDay.subtract(const Duration(hours: 1)),
                meal.endDay.add(const Duration(hours: 1)),
                day) ||
            isSameDay(meal.startDay, day))
        .toList();
    print(meals);
    return meals;
  }

  PlannendMealModel? _getMealForTheDay(DateTime day) {
    var meals = plannedMeals
        .where((meal) =>
            Global.isDateInRange(
                meal.startDay.subtract(const Duration(hours: 1)),
                meal.endDay.add(const Duration(hours: 1)),
                day) ||
            isSameDay(meal.startDay, day))
        .toList();

    if (meals.isEmpty) {
      return null;
    }
    return meals.first;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BasicCard(
          height: 150,
          child: TableCalendar(
            locale: 'de_DE',
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            availableCalendarFormats: const {
              // CalendarFormat.month : 'Monat',
              // CalendarFormat.twoWeeks : '2 Wochen',
              CalendarFormat.week: 'Woche',
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                var meal = event as PlannendMealModel;
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: meal.color,
                  ),
                  width: 7.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                );
              },
            ),
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2099, 3, 14),
            focusedDay: _focusedDay,
          ),
        ),
        SelectedDayMeal(meal: _getMealForTheDay(_selectedDay!))
      ],
    );
  }
}

class SelectedDayMeal extends StatelessWidget {
  final PlannendMealModel? meal;

  const SelectedDayMeal({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      padding: 10,
      child: meal != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Rezept: " + meal!.recipe),
                Text("Ersteller: " + meal!.creator),
                Text("Vom " + Global.datetimeToDeString(meal!.startDay)),
                Text("bis " + Global.datetimeToDeString(meal!.endDay)),
              ],
            )
          : const Center(
              child: Text("Noch kein Essen geplant!"),
            ),
    );
  }
}
