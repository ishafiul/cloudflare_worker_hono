// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_todo_dto_status.dart';

part 'create_todo_dto.freezed.dart';
part 'create_todo_dto.g.dart';

@Freezed()
class CreateTodoDto with _$CreateTodoDto {
  const factory CreateTodoDto({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String completedAt,
    required String taskDate,
    required CreateTodoDtoStatus status,
    required num setAlarmBeforeMin,
  }) = _CreateTodoDto;
  
  factory CreateTodoDto.fromJson(Map<String, Object?> json) => _$CreateTodoDtoFromJson(json);
}
