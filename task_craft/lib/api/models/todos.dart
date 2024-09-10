// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'todo.dart';

part 'todos.freezed.dart';
part 'todos.g.dart';

@Freezed()
class Todos with _$Todos {
  const factory Todos({
    required num pageNumber,
    required num perPageCount,
    required List<Todo> data,
  }) = _Todos;
  
  factory Todos.fromJson(Map<String, Object?> json) => _$TodosFromJson(json);
}
