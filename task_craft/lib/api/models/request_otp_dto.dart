// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_otp_dto.freezed.dart';
part 'request_otp_dto.g.dart';

@Freezed()
class RequestOtpDto with _$RequestOtpDto {
  const factory RequestOtpDto({
    required String email,
    required String deviceUuid,
  }) = _RequestOtpDto;
  
  factory RequestOtpDto.fromJson(Map<String, Object?> json) => _$RequestOtpDtoFromJson(json);
}
