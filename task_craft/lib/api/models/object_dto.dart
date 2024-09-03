// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'object_dto.freezed.dart';
part 'object_dto.g.dart';

@Freezed()
class ObjectDto with _$ObjectDto {
  const factory ObjectDto({
    required String deviceType,
    required String osName,
    required String osVersion,
    required String deviceModel,
    required bool isPhysicalDevice,
    required String appVersion,
    required String ipAddress,
    required String fcmToken,
  }) = _ObjectDto;
  
  factory ObjectDto.fromJson(Map<String, Object?> json) => _$ObjectDtoFromJson(json);
}
