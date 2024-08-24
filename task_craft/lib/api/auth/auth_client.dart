// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/object_dto.dart';
import '../models/object_dto2.dart';
import '../models/object_dto3.dart';
import '../models/post_auth_create_device_uuid_response.dart';
import '../models/post_auth_req_otp_response.dart';
import '../models/post_auth_verify_otp_response.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// [body] - Name not received and was auto-generated.
  @POST('/auth/createDeviceUuid')
  Future<PostAuthCreateDeviceUuidResponse> postAuthCreateDeviceUuid({
    @Body() ObjectDto? body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// [body] - Name not received and was auto-generated.
  @POST('/auth/reqOtp')
  Future<PostAuthReqOtpResponse> postAuthReqOtp({
    @Body() ObjectDto2? body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// [body] - Name not received and was auto-generated.
  @POST('/auth/verifyOtp')
  Future<PostAuthVerifyOtpResponse> postAuthVerifyOtp({
    @Body() ObjectDto3? body,
    @Extras() Map<String, dynamic>? extras,
  });
}
