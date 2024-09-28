import 'package:flutter/material.dart';

import '../../data/model/todo.dart';
import 'todo_item_view.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> todos;
  const TodoListView({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoItemView(todo: todos[index]);
      },
    );
  }
}
