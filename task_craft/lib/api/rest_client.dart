// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';

import 'auth/auth_client.dart';
import 'client/client_client.dart';

/// Auth API `vv1`
class RestClient {
  RestClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  AuthClient? _auth;
  ClientClient? _client;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  ClientClient get client => _client ??= ClientClient(_dio, baseUrl: _baseUrl);
}
