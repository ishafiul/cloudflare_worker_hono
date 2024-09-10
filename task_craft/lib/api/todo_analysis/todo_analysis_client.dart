// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/todos_count_entity.dart';

part 'todo_analysis_client.g.dart';

@RestApi()
abstract class TodoAnalysisClient {
  factory TodoAnalysisClient(Dio dio, {String? baseUrl}) = _TodoAnalysisClient;

  /// Get a count of todos for each date in a given month and year
  @GET('/todo/analysis/month-todo-count')
  Future<TodosCountEntity> getTodoAnalysisMonthTodoCount({
    @Query('year') required String year,
    @Query('month') required String month,
  });
}
