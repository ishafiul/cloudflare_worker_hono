// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';

import 'auth/auth_client.dart';
import 'todo/todo_client.dart';

/// Todo API `vv1`
class RestClient {
  RestClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  AuthClient? _auth;
  TodoClient? _todo;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  TodoClient get todo => _todo ??= TodoClient(_dio, baseUrl: _baseUrl);
}
