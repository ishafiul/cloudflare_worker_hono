// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'object_dto3.freezed.dart';
part 'object_dto3.g.dart';

@Freezed()
class ObjectDto3 with _$ObjectDto3 {
  const factory ObjectDto3({
    required String email,
    required String deviceUuid,
    required num otp,
  }) = _ObjectDto3;
  
  factory ObjectDto3.fromJson(Map<String, Object?> json) => _$ObjectDto3FromJson(json);
}
