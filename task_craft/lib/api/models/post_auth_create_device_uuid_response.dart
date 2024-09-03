// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_auth_create_device_uuid_response.freezed.dart';
part 'post_auth_create_device_uuid_response.g.dart';

@Freezed()
class PostAuthCreateDeviceUuidResponse with _$PostAuthCreateDeviceUuidResponse {
  const factory PostAuthCreateDeviceUuidResponse({
    required String deviceUuid,
  }) = _PostAuthCreateDeviceUuidResponse;
  
  factory PostAuthCreateDeviceUuidResponse.fromJson(Map<String, Object?> json) => _$PostAuthCreateDeviceUuidResponseFromJson(json);
}
