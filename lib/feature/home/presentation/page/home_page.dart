import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../../data/model/todo.dart';
import '../view/todo_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a GlobalKey to access the Scaffold's context
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocProvider(
      create: (_) => HomeCubit()..fetchTodos(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (BuildContext context, HomeState state) {
            log('Listener triggered with state: $state');

            if (state is HomeSuccessCreate) {
              log('HomeSuccessCreate state received in listener');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Todo created successfully: ${state.createdTodo.title}'),
                ),
              );
            } else if (state is HomeSuccessUpdate) {
              log('HomeSuccessUpdate state received in listener');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Todo updated successfully: ${state.updatedTodo.title}'),
                ),
              );
            } else if (state is HomeSuccessDelete) {
              log('HomeSuccessDelete state received in listener');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todo deleted successfully')),
              );
            } else if (state is HomeErrorState) {
              log('HomeErrorState received in listener');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (BuildContext context, HomeState state) {
            if (state is HomeLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeSuccessState) {
              return TodoListView(todos: state.todos);
            } else if (state is HomeSuccessCreate) {
              return TodoListView(todos: state.todos);
            } else if (state is HomeSuccessUpdate) {
              return TodoListView(todos: state.todos);
            } else if (state is HomeSuccessDelete) {
              return TodoListView(todos: state.todos);
            } else if (state is HomeErrorState) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(
                child: Text('Press the button to load todos.'),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String? title = await _showCreateTodoDialog(context);
            if (title != null && title.isNotEmpty) {
              final Todo newTodo = Todo(
                userId: 1,
                title: title,
                completed: false,
              );
              context.read<HomeCubit>().createTodo(newTodo);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<String?> _showCreateTodoDialog(BuildContext context) async {
    String title = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create New Todo'),
        content: TextField(
          onChanged: (String value) {
            title = value;
          },
          decoration: const InputDecoration(hintText: 'Enter todo title'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(title),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
