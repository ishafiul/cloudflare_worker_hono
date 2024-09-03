// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_auth_logout_response.freezed.dart';
part 'delete_auth_logout_response.g.dart';

@Freezed()
class DeleteAuthLogoutResponse with _$DeleteAuthLogoutResponse {
  const factory DeleteAuthLogoutResponse({
    required String message,
  }) = _DeleteAuthLogoutResponse;
  
  factory DeleteAuthLogoutResponse.fromJson(Map<String, Object?> json) => _$DeleteAuthLogoutResponseFromJson(json);
}
