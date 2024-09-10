import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/api/models/todo.dart';
import 'package:task_craft/api/models/todos.dart';
import 'package:task_craft/api/rest_client.dart';
import 'package:task_craft/bootstrap.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/utils/http_base_interceptor.dart';

part 'get_todos_state.dart';

class GetTodosCubit extends Cubit<GetTodosState> {
  GetTodosCubit() : super(GetTodosInitial());

  Future<void> getTodos({required DateTime taskDate}) async {
    final dio = Dio();
    dio.interceptors.add(BaseInterceptor());
    final restClient = RestClient(dio, baseUrl: EnvProd.host);
    logger.i(taskDate.toIso8601String());
    try {
      final res =
          await restClient.todo.getTodo(taskDate: taskDate.toIso8601String());
      emit(GetTodosSuccess(res));
    } catch (e) {
      emit(GetTodosFailed());
    }
  }

  void updateTodoInList({required Todo todo}) {
    // Return if the state is not `GetTodosSuccess`
    if (state is! GetTodosSuccess) return;
    logger.d(todo);
    final currentState = state as GetTodosSuccess;
    final todos = currentState.todos;

    // Create a new list by updating only the necessary todo
    final updatedTodos = todos.copyWith(
      data: todos.data
          .map((e) => e.id == todo.id ? todo : e)
          .toList(),
    );

    logger.d(updatedTodos);

    // Emit the updated state
    emit(GetTodosSuccess(updatedTodos));
  }

}
