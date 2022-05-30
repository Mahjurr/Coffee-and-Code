import 'package:units/dreams/views/calendar/eventeditingpage.dart';
import 'package:provider/provider.dart';
import 'calendar.dart';
import 'package:flutter/material.dart';
import 'eventprovider.dart';
import '../../utils/app_colors.dart' as AppColors;

Future main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = "Calendar Event ";
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => EventProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: MainPage(),
    ),
  );
}


class MainPage extends StatelessWidget{
  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.darkBackground,
      title: Text(MyApp.title),
      centerTitle: true,
    ),
    body: Calendar(),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add,
          color: Colors.white),
      backgroundColor: AppColors.darkBackground,
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EventEditingPage()),
      ),
    ),
  );
}
