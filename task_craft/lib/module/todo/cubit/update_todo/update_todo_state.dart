part of 'update_todo_cubit.dart';

@immutable
sealed class UpdateTodoState {}

final class UpdateTodoInitial extends UpdateTodoState {}

final class UpdateTodoLoading extends UpdateTodoState {}

final class UpdateTodoSuccess extends UpdateTodoState {
  final Todo todo;

  UpdateTodoSuccess(this.todo);
}

final class UpdateTodoError extends UpdateTodoState {}
