import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/api/models/object_dto3.dart';
import 'package:task_craft/api/rest_client.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/service/local/app_state.dart';
import 'package:task_craft/core/utils/app_state_collection_isar.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpInitial());

  Future<void> verifyOtp({
    required int otp,
    required String email,
    required String deviceUuid,
  }) async {
    emit(VerifyOtpLoading());

    try {
      final dio = Dio();
      final restClient = RestClient(dio, baseUrl: EnvProd.host);

      final result = await restClient.auth.postAuthVerifyOtp(
        body: ObjectDto3(
          otp: otp,
          email: email,
          deviceUuid: deviceUuid,
        ),
      );

      final appState = AppStateService();
      await appState.initLocalDbUser(User());
      await appState.updateAccessToken(result.accessToken);
      await appState.updateDeviceUuid(deviceUuid);
      // await appState.updateUserID(result.userId);

      emit(VerifyOtpSuccess());
    } catch (e) {
      String errorMessage;

      if (e is DioException) {
        errorMessage =
            'OTP verification failed: ${e.response?.statusCode} - ${e.response?.statusMessage}';
      } else {
        errorMessage = 'An unexpected error occurred: $e';
      }

      emit(
        VerifyOtpError(
          message: errorMessage,
        ),
      );
    }
  }
}
