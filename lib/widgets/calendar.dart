import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';

class SimpleCalendarPage extends StatefulWidget {
  @override
  _SimpleCalendarPageState createState() => _SimpleCalendarPageState();
}

class _SimpleCalendarPageState extends State<SimpleCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              calendarStyle:
              CalendarStyle(rangeHighlightColor: MyColors.baseOrangeColor),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {
                      String time = _selectedDay!.day.toString() + "-" + _selectedDay!.month.toString() + "-" + _selectedDay!.year.toString();
                      Navigator.pop(context, time);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(MyColors.baseOrangeColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0))),
                    ),
                    child: Text("Save", style: TextStyle(color: Colors.white),),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.white,
                      child: Center(child: Text("Close", style: TextStyle(color: MyColors.baseOrangeColor))),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
