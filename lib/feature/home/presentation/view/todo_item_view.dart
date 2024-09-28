import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../data/model/todo.dart';

class TodoItemView extends StatelessWidget {
  final Todo todo;
  const TodoItemView({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) {
          final updatedTodo = todo.copyWith(completed: value ?? false);
          context.read<HomeCubit>().updateTodo(updatedTodo);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          context.read<HomeCubit>().deleteTodo(todo.id!);
        },
      ),
    );
  }
}
