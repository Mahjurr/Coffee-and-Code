import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import '../utils/app_colors.dart' as AppColors;

class Alarm extends StatefulWidget {
  const Alarm({Key? key}) : super(key: key);

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: const Text('Flutter alarm clock example'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: Center(
            child: Column(children: <Widget>[

              Container(
                margin: const EdgeInsets.all(25),
                child: TextButton(
                  child: const Text(
                    'selectTime',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    await _selectTime(context);
                    FlutterAlarmClock.createAlarm(selectedTime.hour, selectedTime.minute);
                  },
                ),
              ),
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                child: const Text(
                  'Create alarm at 23:59',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  FlutterAlarmClock.createAlarm(23, 59);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                child: const Text(
                  'Show alarms',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  FlutterAlarmClock.showAlarms();
                },
              ),
            ),
        ])),
      ),

    );
  }
}
