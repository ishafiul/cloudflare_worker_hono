import 'package:dio/dio.dart';
import 'package:task_craft/app/app_router.dart';
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
    final appState = AppStateService();
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
      router.go('/auth');
      return;
      final dio = Dio();
      try {
        const String newToken = '';
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
