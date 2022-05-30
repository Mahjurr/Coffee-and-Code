import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/main.dart';
import '../presenter/dreams_presenter.dart';
import 'home_screen.dart';
import '../utils/app_colors.dart' as AppColors;

class Log_Page extends StatefulWidget {
  final UNITSPresenter presenter;

  Log_Page(this.presenter, {required Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  _LogPageState createState() => _LogPageState();
}

void main() => runApp(MyApp());

class _LogPageState extends State<Log_Page> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Log(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColors.darkBackground,
            scaffoldBackgroundColor: AppColors.darkBackground));
  }
}

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  String title = "";
  String input = "";
  List<String> todo = []; //todo = Coffee Journal

  //void initState (){
  //todo.add("cycle");
  //super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        /*
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Text("Coffee Journal",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        */
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.textField,
          child: Icon(
            Icons.add,
            color: AppColors.lightAccent,
            size: 35,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    //backgroundColor: Color(0xffF48C8C),
                    title: Text("Add a Coffee Journal"),
                    content: TextField(
                      decoration:
                          InputDecoration(hintText: "What did you make today?"),
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              todo.add(input);
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Log",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  );
                });
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: todo.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: Key(todo[index]),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListTile(
                        title: Text(
                          todo[index],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              todo.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ));
              }),
        ),
      ),
    );
  }
}
