// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'todo_status.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@Freezed()
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String completedAt,
    required String taskDate,
    required TodoStatus status,
    required num setAlarmBeforeMin,
  }) = _Todo;
  
  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}
