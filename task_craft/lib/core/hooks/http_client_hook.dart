import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/utils/http_base_interceptor.dart';

/// [Dio] hook
Dio useDioHook() {
  return use(const _DioHook());
}

class _DioHook extends Hook<Dio> {
  const _DioHook();

  @override
  __DioHookState createState() => __DioHookState();
}

class __DioHookState extends HookState<Dio, _DioHook> {
  Dio? dio;

  @override
  void initHook() {
    super.initHook();
    dio = Dio();
    dio?.interceptors.add(BaseInterceptor());
    dio?.options.baseUrl = EnvProd.host;
  }

  @override
  Dio build(BuildContext context) {
    return dio!;
  }

  @override
  void dispose() {
    dio!.close();
    super.dispose();
  }
}
