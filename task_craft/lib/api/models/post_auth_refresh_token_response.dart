// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_auth_refresh_token_response.freezed.dart';
part 'post_auth_refresh_token_response.g.dart';

@Freezed()
class PostAuthRefreshTokenResponse with _$PostAuthRefreshTokenResponse {
  const factory PostAuthRefreshTokenResponse({
    required String accessToken,
  }) = _PostAuthRefreshTokenResponse;
  
  factory PostAuthRefreshTokenResponse.fromJson(Map<String, Object?> json) => _$PostAuthRefreshTokenResponseFromJson(json);
}
