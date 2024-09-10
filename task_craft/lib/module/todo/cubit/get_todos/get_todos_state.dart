part of 'get_todos_cubit.dart';

@immutable
sealed class GetTodosState {}

final class GetTodosInitial extends GetTodosState {}

final class GetTodosSuccess extends GetTodosState {
  final Todos todos;

  GetTodosSuccess(this.todos);
}

final class GetTodosFailed extends GetTodosState {}
