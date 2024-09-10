// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_todo_dto.dart';
import '../models/delete_todo_todo_id_response.dart';
import '../models/get_todo_month_todo_count_response.dart';
import '../models/todo.dart';
import '../models/todos.dart';

part 'todo_client.g.dart';

@RestApi()
abstract class TodoClient {
  factory TodoClient(Dio dio, {String? baseUrl}) = _TodoClient;

  /// Create a new todo item
  @POST('/todo')
  Future<Todo> postTodo({
    @Body() required CreateTodoDto body,
  });

  /// Get a list of todos with pagination and date filtering.
  ///
  /// [page] - The page number for pagination.
  ///
  /// [perPage] - Number of items per page.
  ///
  /// [taskDate] - Filter todos by task date (in YYYY-MM-DD format).
  @GET('/todo')
  Future<Todos> getTodo({
    @Query('taskDate') String? taskDate,
    @Query('page') int page = 1,
    @Query('perPage') int perPage = 20,
  });

  /// Update an existing todo item
  @PUT('/todo/{todoId}')
  Future<Todo> putTodoTodoId({
    @Path('todoId') required String todoId,
    @Body() required CreateTodoDto body,
  });

  /// Get a specific todo item by ID
  @GET('/todo/{todoId}')
  Future<Todo> getTodoTodoId({
    @Path('todoId') required String todoId,
  });

  /// Delete a specific todo item by ID
  @DELETE('/todo/{todoId}')
  Future<DeleteTodoTodoIdResponse> deleteTodoTodoId({
    @Path('todoId') required String todoId,
  });

  /// Get a count of todos for each date in a given month and year
  @GET('/todo/month-todo-count')
  Future<GetTodoMonthTodoCountResponse> getTodoMonthTodoCount({
    @Query('year') required String year,
    @Query('month') required String month,
  });
}
