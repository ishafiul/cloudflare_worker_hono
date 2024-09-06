// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp_dto.freezed.dart';
part 'verify_otp_dto.g.dart';

@Freezed()
class VerifyOtpDto with _$VerifyOtpDto {
  const factory VerifyOtpDto({
    required String email,
    required String deviceUuid,
    required num otp,
  }) = _VerifyOtpDto;
  
  factory VerifyOtpDto.fromJson(Map<String, Object?> json) => _$VerifyOtpDtoFromJson(json);
}
