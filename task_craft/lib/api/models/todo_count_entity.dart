// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_count_entity.freezed.dart';
part 'todo_count_entity.g.dart';

@Freezed()
class TodoCountEntity with _$TodoCountEntity {
  const factory TodoCountEntity({
    required String taskDate,
    required int count,
  }) = _TodoCountEntity;
  
  factory TodoCountEntity.fromJson(Map<String, Object?> json) => _$TodoCountEntityFromJson(json);
}
