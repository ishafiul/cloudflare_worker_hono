part of 'todo_count_cubit.dart';

@immutable
sealed class TodoCountState {}

final class TodoCountInitial extends TodoCountState {}

final class TodoCountSuccess extends TodoCountState {
  final TodosCountEntity counts;

  TodoCountSuccess(this.counts);
}
