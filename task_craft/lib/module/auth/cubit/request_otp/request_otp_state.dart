part of 'request_otp_cubit.dart';

@immutable
abstract class RequestOtpState {}

class RequestOtpInitial extends RequestOtpState {}

class RequestOtpLoading extends RequestOtpState {}

class RequestOtpSuccess extends RequestOtpState {
  final String email;
  final String deviceUuid;

  RequestOtpSuccess({
    required this.email,
    required this.deviceUuid,
  });
}

class RequestOtpFailure extends RequestOtpState {
  final String message;

  RequestOtpFailure({required this.message});
}