import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/api/rest_client.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/config/get_it.dart';
import 'package:task_craft/core/service/local/app_state.dart';
import 'package:task_craft/core/utils/http_base_interceptor.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final dio = Dio();
      dio.interceptors.add(BaseInterceptor());
      final restClient = RestClient(dio, baseUrl: EnvProd.host);

      await restClient.auth.deleteAuthLogout();
      final appState = getIt<AppStateService>();

     try {
        await appState.updateAccessToken('');
        emit(
          LogoutSuccess(),
        );
      } catch (e) {
        print(e);
      }


    } catch (e) {
      String errorMessage;

      if (e is DioException) {
        errorMessage =
            'Failed to request OTP: ${e.response?.data['message'] ?? e.message}';
      } else {
        errorMessage = 'An unexpected error occurred: $e';
      }

      emit(
        LogoutFailed(
          message: errorMessage,
        ),
      );
    }
  }
}
