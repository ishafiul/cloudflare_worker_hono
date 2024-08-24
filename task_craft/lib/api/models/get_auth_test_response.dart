// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_auth_test_response.freezed.dart';
part 'get_auth_test_response.g.dart';

@Freezed()
class GetAuthTestResponse with _$GetAuthTestResponse {
  const factory GetAuthTestResponse({
    required String message,
  }) = _GetAuthTestResponse;
  
  factory GetAuthTestResponse.fromJson(Map<String, Object?> json) => _$GetAuthTestResponseFromJson(json);
}
