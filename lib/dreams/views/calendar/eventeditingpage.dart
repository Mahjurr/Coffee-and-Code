import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:units/dreams/views/calendar/utils.dart';
import 'package:units/dreams/views/calendar/event.dart';
import 'package:units/dreams/views/calendar/eventprovider.dart';
import '../../utils/app_colors.dart' as AppColors;

class EventEditingPage extends StatefulWidget{
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }): super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}
class _EventEditingPageState extends State<EventEditingPage>{
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool isAllDay = false;

  @override
  void initState(){
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
      isAllDay = event.isAllDay;
    }
  }

  @override
  void dispose(){
    titleController.dispose();
    descriptionController.dispose(); //Add to group file

    super.dispose();
  }
  //Closing and saving button on top of app
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.darkBackground,
    appBar: AppBar(
      leading: CloseButton(),
      backgroundColor: AppColors.darkBackground,
      actions:buildEditingActions(),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTitle(),
            SizedBox(height: 12),
            buildDateTimePickers(),
            SizedBox(height: 12),
            buildDescription(), //add to group project
          ],
        ),
      ),
    ),
  );

  List<Widget> buildEditingActions() =>[
    ElevatedButton.icon(
      onPressed: saveForm,
      icon: Icon(Icons.done),
      label: Text("SAVE"),
    ),
  ];

  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24, color: Colors.white),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add Title",
      hintStyle: TextStyle(fontSize: 24, color: Colors.white),
    ),
    onFieldSubmitted: (_) => saveForm(),
    validator: (title) =>
    title != null && title.isEmpty ? "Title Cannnot Be Empty" : null,
    controller: titleController,
  );

  Widget buildDescription() => TextFormField(
    style: TextStyle(fontSize: 14, color: Colors.white),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Add Details',
      hintStyle: TextStyle(fontSize: 14, color: Colors.white)
    ),
    textInputAction: TextInputAction.newline,
    maxLines: 5,
    onFieldSubmitted: (_) => saveForm(),
    controller: descriptionController,
  );

  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
      if (!isAllDay) buildTo(),
      CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('All Day Event', style: TextStyle(color: Colors.white),),
        value: isAllDay,
        activeColor: AppColors.darkBackground,
        onChanged: (value) => setState(() => isAllDay = value!),
      )
    ],
  );

  Widget buildFrom() => buildHeader(
    header:"FROM",
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: Utils.toDate(fromDate),
            onClicked: () => pickFromDateTime(pickDate: true),

          ),
        ),
        if (!isAllDay)
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          ),
      ],
    ),
  );

  Widget buildTo() => buildHeader(
    header:"TO",
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: Utils.toDate(toDate),
            onClicked: () => pickToDateTime(pickDate:true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(toDate),
            onClicked: () => pickToDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );

  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if(date == null) return;

    if(date.isAfter(toDate)){
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }


  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(toDate, pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if(date == null) return;

    if(date.isAfter(toDate)){
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate,{
        required bool pickDate,
        DateTime? firstDate,
      }) async{
    if(pickDate){
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2000,8),
          lastDate: DateTime(2100)
      );
      if(date == null) return null;
      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);

    } else{
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if(timeOfDay == null) return null;

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }


  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text, style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.white,),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(header, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            child,
          ],
        ),
      );

// to save events including date, time and description
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: isAllDay ? fromDate : toDate,
        isAllDay: isAllDay,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);

        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }
}

