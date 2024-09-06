import 'package:dio/dio.dart';
import 'package:task_craft/api/auth/auth_client.dart';
import 'package:task_craft/api/models/refresh_token_dto.dart';
import 'package:task_craft/app/app_router.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/config/get_it.dart';
import 'package:task_craft/core/service/local/app_state.dart';

/// Base [Interceptor] for [Dio]. This interceptor is responsible for
/// adding the `Authorization` header. If any request receives a response with a `401` status code,
/// it will attempt to refresh the token and then retry the request.
class BaseInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final appState = getIt<AppStateService>();
    final String? token = await appState.getUserAccessToken();
    options.headers['Authorization'] = 'Bearer $token';

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final dio = Dio();
      try {
        dio.options.baseUrl = EnvProd.host;
        final client = AuthClient(dio);
        final appState = getIt<AppStateService>();

        final deviceUuid = await appState.getUserRefreshToken();
        if (deviceUuid == null) {
          router.go('/auth');
          return;
        }
        final res = await client.postAuthRefreshToken(
          body: RefreshTokenDto(deviceUuid: deviceUuid),
        );
        final String newToken = res.accessToken;
        await appState.updateAccessToken(newToken);
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        return handler.resolve(await dio.fetch(err.requestOptions));
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          router.go('/auth');
          return;
        }
      }
    }
    super.onError(err, handler);
  }
}
