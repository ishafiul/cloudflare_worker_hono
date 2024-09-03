import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/api/export.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/utils/funtions.dart';

part 'request_otp_state.dart';

class RequestOtpCubit extends Cubit<RequestOtpState> {
  RequestOtpCubit() : super(RequestOtpInitial());

  Future<void> requestOtp(String email) async {
    emit(RequestOtpLoading());

    try {
      final dio = Dio();
      final restClient = RestClient(dio, baseUrl: EnvProd.host);

      final deviceInfo = await rawDeviceInfo();

      final deviceUuid =
          await restClient.auth.postAuthCreateDeviceUuid(body: deviceInfo);

      if (deviceUuid.deviceUuid.isEmpty) {
        emit(
          RequestOtpFailure(
            message: 'Something went wrong creating device UUID.',
          ),
        );
        return;
      }

      await restClient.auth.postAuthReqOtp(
        body: ObjectDto2(email: email, deviceUuid: deviceUuid.deviceUuid),
      );

      emit(
        RequestOtpSuccess(
          email: email,
          deviceUuid: deviceUuid.deviceUuid,
        ),
      );
    } catch (e) {
      String errorMessage;

      if (e is DioException) {
        errorMessage =
            'Failed to request OTP: ${e.response?.data['message'] ?? e.message}';
      } else {
        errorMessage = 'An unexpected error occurred: $e';
      }

      emit(
        RequestOtpFailure(
          message: errorMessage,
        ),
      );
    }
  }
}
