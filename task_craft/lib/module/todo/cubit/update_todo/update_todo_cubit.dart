import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/api/export.dart';
import 'package:task_craft/api/models/todo.dart';
import 'package:task_craft/api/rest_client.dart';
import 'package:task_craft/bootstrap.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/utils/http_base_interceptor.dart';

part 'update_todo_state.dart';

class UpdateTodoCubit extends Cubit<UpdateTodoState> {
  UpdateTodoCubit() : super(UpdateTodoInitial());

  Future<void> updateTodo({required Todo todo}) async {
    emit(UpdateTodoLoading());
    final dio = Dio();
    dio.interceptors.add(BaseInterceptor());
    final restClient = RestClient(dio, baseUrl: EnvProd.host);

    final updatedTodo = await restClient.todo.putTodoTodoId(
      todoId: todo.id,
      body: CreateTodoDto(
        title: todo.title,
        description: todo.description,
        startTime: todo.startTime,
        endTime: todo.endTime,
        completedAt: todo.status == TodoStatus.completed
            ? DateTime.now().toIso8601String()
            : todo.completedAt,
        taskDate: todo.taskDate,
        status: CreateTodoDtoStatus.fromJson(todo.status.toJson() ?? ""),
        setAlarmBeforeMin: todo.setAlarmBeforeMin,
      ),
    );
    logger.d(updatedTodo);
    emit(UpdateTodoSuccess(updatedTodo));
  }
}
