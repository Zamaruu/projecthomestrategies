import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/plannedmeal_model.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/basiccard.dart';
import 'package:projecthomestrategies/widgets/pages/recipes/mealplanner/selecteddaymeals.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlannerCalendar extends StatefulWidget {
  final List<PlannedMealModel> meals;
  final Function refreshPlannings;

  const MealPlannerCalendar(
      {Key? key, required this.meals, required this.refreshPlannings})
      : super(key: key);

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
    var meals = plannedMeals
        .where((meal) =>
            Global.isDateInRange(
                meal.startDay!.subtract(const Duration(hours: 1)),
                meal.endDay!.add(const Duration(hours: 1)),
                day) ||
            isSameDay(meal.startDay, day))
        .toList();
    return meals;
  }

  List<PlannedMealModel>? _getMealsForTheDay(DateTime day) {
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
    return meals;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => widget.refreshPlannings(),
      child: ListView(
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
          SelectedDayMeals(meals: _getMealsForTheDay(_selectedDay!)),
          // SelectedDayMeal(meal: _getMealForTheDay(_selectedDay!))
        ],
      ),
    );
  }
}
