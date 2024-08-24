part of 'user_me_cubit.dart';

@immutable
sealed class UserMeState {}

final class UserMeInitial extends UserMeState {}

final class UserMeLoading extends UserMeState {}

final class UserMeLoaded extends UserMeState {
  final dynamic userMe;

  UserMeLoaded({this.userMe});
}

final class UserMeError extends UserMeState {
  final String? message;

  UserMeError({this.message});
}
