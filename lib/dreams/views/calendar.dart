import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import '../presenter/dreams_presenter.dart';
import '../views/Log_Page.dart';
import '../utils/app_colors.dart' as AppColors;

class Calendar extends StatefulWidget{
  @override
 // State<Calendar> createState() => _CalendarState();
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date){
    return selectedEvents[date]?? [];
  }

  @override
  void dispose(){
    _eventController.dispose();
    super.dispose();
  }

  Widget BuildNavigateButton() => FloatingActionButton.extended(
    backgroundColor: AppColors.textFieldText,
    icon: Icon(Icons.note_add),
    label: Text("Add to Log"),
    onPressed: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return LogPage();
      }));
    },
  );
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Calendar"),
      backgroundColor:AppColors.darkBackground,
      centerTitle: true,
    ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map((Event event) =>
              ListTile(title: Text(event.title),),),
        ],
      ),
        floatingActionButton: BuildNavigateButton(),
    );
  }
}
class Event{
  final String title;
  Event({required this.title});

  String toString() => this.title;
}
class LogPage extends StatefulWidget {
  @override
  _LogPage createState() => _LogPage();
}

class _LogPage extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return new Log_Page (new BasicPresenter(), title: 'Sweet Dreams', key: Key("UNITS"),);
  }
}
