// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_dto.freezed.dart';
part 'refresh_token_dto.g.dart';

@Freezed()
class RefreshTokenDto with _$RefreshTokenDto {
  const factory RefreshTokenDto({
    required String deviceUuid,
  }) = _RefreshTokenDto;
  
  factory RefreshTokenDto.fromJson(Map<String, Object?> json) => _$RefreshTokenDtoFromJson(json);
}
