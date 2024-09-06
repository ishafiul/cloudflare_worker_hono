// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_device_uuid_dto.dart';
import '../models/delete_auth_logout_response.dart';
import '../models/post_auth_create_device_uuid_response.dart';
import '../models/post_auth_refresh_token_response.dart';
import '../models/post_auth_req_otp_response.dart';
import '../models/post_auth_verify_otp_response.dart';
import '../models/refresh_token_dto.dart';
import '../models/request_otp_dto.dart';
import '../models/verify_otp_dto.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// Create device UUID
  @POST('/auth/createDeviceUuid')
  Future<PostAuthCreateDeviceUuidResponse> postAuthCreateDeviceUuid({
    @Body() required CreateDeviceUuidDto body,
  });

  @POST('/auth/reqOtp')
  Future<PostAuthReqOtpResponse> postAuthReqOtp({
    @Body() RequestOtpDto? body,
  });

  @POST('/auth/verifyOtp')
  Future<PostAuthVerifyOtpResponse> postAuthVerifyOtp({
    @Body() VerifyOtpDto? body,
  });

  @DELETE('/auth/logout')
  Future<DeleteAuthLogoutResponse> deleteAuthLogout();

  @POST('/auth/refreshToken')
  Future<PostAuthRefreshTokenResponse> postAuthRefreshToken({
    @Body() RefreshTokenDto? body,
  });
}
