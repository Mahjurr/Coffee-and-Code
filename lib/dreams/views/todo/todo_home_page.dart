import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units/dreams/views/todo/todo_list_widget.dart';
import 'add_todo_dialog_widget.dart';
import 'todo.dart';
import 'todo_list_widget.dart';
import 'todos.dart';
import 'completed_list_widget.dart';
import 'firebase_api.dart';
import 'package:units/dreams/utils/app_colors.dart' as AppColors;

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodoListWidget(),
      CompletedListWidget(),
    ];

    return Scaffold(
      backgroundColor: AppColors.textField,
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.textField,
        unselectedItemColor: AppColors.lightAccent,
        selectedItemColor: AppColors.lightAccent,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: "Todos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: "Completed",
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: FirebaseApi.readTodos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return buildText("Something Went Wrong Try later");
              }
              else {
                final todos = snapshot.data;

               final provider = Provider.of<TodosProvider>(context);
               provider.setTodos(todos!);

                return tabs[selectedIndex];
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.brown,
        onPressed: () => showDialog(
          builder: (context) =>
              AddTodoDialogWidget(), context: context,
          barrierDismissible: true,
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
Widget buildText(String text) => Center(
  child: Text(
    text,
    style: TextStyle(fontSize: 24, color: Colors.brown),
  ),
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  static final String title = "Check List";

  @override
  Widget build(BuildContext context)  => ChangeNotifierProvider(
    create: (context) => TodosProvider(),
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: HomePage(),
    ),
  );
}
