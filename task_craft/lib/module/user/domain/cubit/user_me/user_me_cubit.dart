import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/module/user/domain/repositories/i_user_repository.dart';
import 'package:task_craft/module/user/domain/usecase/get_user_me.dart';

part 'user_me_state.dart';

class UserMeCubit extends Cubit<UserMeState> {
  late final IUserRepository _repository;

  UserMeCubit({required IUserRepository userRepository})
      : super(UserMeInitial()) {
    _repository = userRepository;
  }

  Future<void> getUserMe() async {
    emit(UserMeLoading());
    await _getUserMe();
  }

  Future<void> syncUserMe() async {
    await _getUserMe();
  }

  Future<void> _getUserMe() async {
    final useCase = GetUserMe(userRepository: _repository);
    final result = await useCase.call();
    try {
      emit(UserMeLoaded(userMe: result));
    } catch (e) {
      emit(
        UserMeError(
          message: e.toString(),
        ),
      );
    }
  }
}
