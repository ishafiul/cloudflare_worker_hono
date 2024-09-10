// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'todo_count_entity.dart';

part 'todos_count_entity.freezed.dart';
part 'todos_count_entity.g.dart';

@Freezed()
class TodosCountEntity with _$TodosCountEntity {
  const factory TodosCountEntity({
    required String month,
    required List<TodoCountEntity> data,
  }) = _TodosCountEntity;
  
  factory TodosCountEntity.fromJson(Map<String, Object?> json) => _$TodosCountEntityFromJson(json);
}
