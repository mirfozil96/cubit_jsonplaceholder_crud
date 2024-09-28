import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../data/model/todo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  final Dio _dio = Dio();
  List<Todo> _todos = <Todo>[];

  List<Todo> get todos => List<Todo>.unmodifiable(_todos);

  Future<void> fetchTodos() async {
    emit(HomeLoadingState());
    try {
      final Response<dynamic> response =
          await _dio.get('https://jsonplaceholder.typicode.com/todos');
      if (response.statusCode == 200) {
        _todos = (response.data as List<Todo>)
            .map((Todo item) => Todo.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(HomeSuccessState(List<Todo>.from(_todos)));
      } else {
        emit(const HomeErrorState('Failed to load todos'));
      }
    } catch (e) {
      emit(HomeErrorState('An error occurred: $e'));
    }
  }

  Future<void> createTodo(Todo todo) async {
    emit(HomeLoadingState()); // Optional
    try {
      final Response<dynamic> response = await _dio.post(
        'https://jsonplaceholder.typicode.com/todos',
        data: todo.toJson(),
      );
      log('API Response: ${response.data}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        final Todo createdTodo = Todo.fromJson(responseData);
        _todos.add(createdTodo);
        log('Emitting HomeSuccessCreate state');
        emit(HomeSuccessCreate(createdTodo, List<Todo>.from(_todos)));
      } else {
        emit(const HomeErrorState('Failed to create todo'));
      }
    } catch (e) {
      emit(HomeErrorState('An error occurred: $e'));
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final Response<dynamic> response = await _dio.put(
        'https://jsonplaceholder.typicode.com/todos/${todo.id}',
        data: todo.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        final int index = _todos.indexWhere((Todo t) => t.id == todo.id);
        if (index != -1) {
          _todos[index] = todo;
        }
        emit(HomeSuccessUpdate(todo, List<Todo>.from(_todos)));
      } else {
        emit(const HomeErrorState('Failed to update todo'));
      }
    } catch (e) {
      emit(HomeErrorState('An error occurred: $e'));
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final Response<dynamic> response =
          await _dio.delete('https://jsonplaceholder.typicode.com/todos/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        _todos.removeWhere((Todo todo) => todo.id == id);
        emit(HomeSuccessDelete(id, List<Todo>.from(_todos)));
      } else {
        emit(const HomeErrorState('Failed to delete todo'));
      }
    } catch (e) {
      emit(HomeErrorState('An error occurred: $e'));
    }
  }
}
