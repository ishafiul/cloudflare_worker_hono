// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'get_todo_month_todo_count_response.freezed.dart';
part 'get_todo_month_todo_count_response.g.dart';

@Freezed()
class GetTodoMonthTodoCountResponse with _$GetTodoMonthTodoCountResponse {
  const factory GetTodoMonthTodoCountResponse({
    required String month,
    required List<Data> data,
  }) = _GetTodoMonthTodoCountResponse;
  
  factory GetTodoMonthTodoCountResponse.fromJson(Map<String, Object?> json) => _$GetTodoMonthTodoCountResponseFromJson(json);
}
