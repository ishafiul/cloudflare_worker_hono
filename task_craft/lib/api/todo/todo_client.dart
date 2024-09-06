// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_todo_dto.dart';
import '../models/todo.dart';

part 'todo_client.g.dart';

@RestApi()
abstract class TodoClient {
  factory TodoClient(Dio dio, {String? baseUrl}) = _TodoClient;

  /// Create a new todo item
  @POST('/todo/createTodo')
  Future<Todo> postTodoCreateTodo({
    @Body() required CreateTodoDto body,
  });
}
