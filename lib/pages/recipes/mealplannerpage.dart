import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/basiccard.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/recipecard.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlannerPage extends StatelessWidget {
  final List<PlannedMealModel> meals;

  const MealPlannerPage({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MealPlannerCalendar(
        meals: meals,
      ),
    );
  }
}

class MealPlannerCalendar extends StatefulWidget {
  final List<PlannedMealModel> meals;

  const MealPlannerCalendar({Key? key, required this.meals}) : super(key: key);

  @override
  State<MealPlannerCalendar> createState() => _MealPlannerCalendarState();
}

class _MealPlannerCalendarState extends State<MealPlannerCalendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime? _selectedDay;
  late List<PlannedMealModel> plannedMeals;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    plannedMeals = widget.meals;
  }

  List<PlannedMealModel> _getEventsForDay(DateTime day) {
    print(day);
    var meals = plannedMeals
        .where((meal) =>
            Global.isDateInRange(
                meal.startDay!.subtract(const Duration(hours: 1)),
                meal.endDay!.add(const Duration(hours: 1)),
                day) ||
            isSameDay(meal.startDay, day))
        .toList();
    print(meals);
    return meals;
  }

  PlannedMealModel? _getMealForTheDay(DateTime day) {
    var meals = plannedMeals
        .where((meal) =>
            Global.isDateInRange(
                meal.startDay!.subtract(const Duration(hours: 1)),
                meal.endDay!.add(const Duration(hours: 1)),
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
          height: _calendarFormat == CalendarFormat.week ? 150 : 400,
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
              // CalendarFormat.twoWeeks : '2 Wochen',
              CalendarFormat.week: 'Woche',
              // CalendarFormat.month: 'Monat',
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                var meal = event as PlannedMealModel;
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(meal.color!),
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
        RecipeCard(recipe: _getMealForTheDay(_selectedDay!)!.recipe!),
        // SelectedDayMeal(meal: _getMealForTheDay(_selectedDay!))
      ],
    );
  }
}

class SelectedDayMeal extends StatelessWidget {
  final PlannedMealModel? meal;

  const SelectedDayMeal({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BasicCard(
          padding: 10,
          child: meal != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Vom " + Global.datetimeToDeString(meal!.startDay!)),
                    Text("bis " + Global.datetimeToDeString(meal!.endDay!)),
                  ],
                )
              : const Center(
                  child: Text("Noch kein Essen geplant!"),
                ),
        ),
      ],
    );
  }
}
