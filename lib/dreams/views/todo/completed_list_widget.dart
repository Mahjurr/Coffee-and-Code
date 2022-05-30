import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todos.dart';
import 'todo_widget.dart';
import 'package:units/dreams/utils/app_colors.dart' as AppColors;

class CompletedListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todosCompleted;

    return todos.isEmpty
        ? Center(
      child:Text(
        "No todos!",
        style: TextStyle(fontSize: 20, color: AppColors.lightAccent),
      ),
    )
        :ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index){
        final todo = todos[index];

        return TodoWidget(todo: todo);
      },
    );
  }
}
