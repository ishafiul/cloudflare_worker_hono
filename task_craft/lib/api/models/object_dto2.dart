// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'object_dto2.freezed.dart';
part 'object_dto2.g.dart';

@Freezed()
class ObjectDto2 with _$ObjectDto2 {
  const factory ObjectDto2({
    required String email,
    required String deviceUuid,
  }) = _ObjectDto2;
  
  factory ObjectDto2.fromJson(Map<String, Object?> json) => _$ObjectDto2FromJson(json);
}
