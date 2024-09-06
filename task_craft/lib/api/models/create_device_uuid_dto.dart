// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_device_uuid_dto.freezed.dart';
part 'create_device_uuid_dto.g.dart';

@Freezed()
class CreateDeviceUuidDto with _$CreateDeviceUuidDto {
  const factory CreateDeviceUuidDto({
    required String deviceType,
    required String osName,
    required String osVersion,
    required String deviceModel,
    required bool isPhysicalDevice,
    required String appVersion,
    required String ipAddress,
    required String fcmToken,
  }) = _CreateDeviceUuidDto;
  
  factory CreateDeviceUuidDto.fromJson(Map<String, Object?> json) => _$CreateDeviceUuidDtoFromJson(json);
}
