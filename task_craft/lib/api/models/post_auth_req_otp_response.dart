// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_auth_req_otp_response.freezed.dart';
part 'post_auth_req_otp_response.g.dart';

@Freezed()
class PostAuthReqOtpResponse with _$PostAuthReqOtpResponse {
  const factory PostAuthReqOtpResponse({
    required String message,
  }) = _PostAuthReqOtpResponse;
  
  factory PostAuthReqOtpResponse.fromJson(Map<String, Object?> json) => _$PostAuthReqOtpResponseFromJson(json);
}
