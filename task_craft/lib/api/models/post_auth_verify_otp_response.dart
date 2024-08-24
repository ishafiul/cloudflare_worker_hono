// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_auth_verify_otp_response.freezed.dart';
part 'post_auth_verify_otp_response.g.dart';

@Freezed()
class PostAuthVerifyOtpResponse with _$PostAuthVerifyOtpResponse {
  const factory PostAuthVerifyOtpResponse({
    required String accessToken,
  }) = _PostAuthVerifyOtpResponse;
  
  factory PostAuthVerifyOtpResponse.fromJson(Map<String, Object?> json) => _$PostAuthVerifyOtpResponseFromJson(json);
}
