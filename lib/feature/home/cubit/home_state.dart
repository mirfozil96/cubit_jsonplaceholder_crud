import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../data/model/todo.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => <Object?>[];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  const HomeSuccessState(this.todos);
  final List<Todo> todos;

  @override
  List<Object?> get props => <Object?>[todos];
}

class HomeSuccessCreate extends HomeState {
  const HomeSuccessCreate(this.createdTodo, this.todos);
  final Todo createdTodo;
  final List<Todo> todos;

  @override
  List<Object?> get props => <Object?>[createdTodo, todos];
}

class HomeSuccessUpdate extends HomeState {
  const HomeSuccessUpdate(this.updatedTodo, this.todos);
  final Todo updatedTodo;
  final List<Todo> todos;

  @override
  List<Object?> get props => <Object?>[updatedTodo, todos];
}

class HomeSuccessDelete extends HomeState {
  const HomeSuccessDelete(this.deletedTodoId, this.todos);
  final int deletedTodoId;
  final List<Todo> todos;

  @override
  List<Object?> get props => <Object?>[deletedTodoId, todos];
}

class OperationSuccessState extends HomeState {
  const OperationSuccessState(this.message, [this.todo]);
  final String message;
  final Todo? todo;

  @override
  List<Object?> get props => <Object?>[message, todo];
}

class HomeErrorState extends HomeState {
  const HomeErrorState(this.errorMessage);
  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[errorMessage];
}
