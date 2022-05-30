import 'package:units/dreams/views/calendar/eventdatasource.dart';
import 'package:units/dreams/views/calendar/tasks.dart';
import 'package:provider/provider.dart';
import 'package:units/dreams/views/calendar/eventprovider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../utils/app_colors.dart' as AppColors;


class Calendar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      todayHighlightColor: AppColors.darkBackground,


//add to group file
      onSelectionChanged: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
      },
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        if (provider.selectedDate == details.date) {
          showModalBottomSheet(
            context: context,
            builder: (context) => Tasks(),
          );
        }
      },

      onLongPress: (details){
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => Tasks(),
        );
      },
    );
  }
}
