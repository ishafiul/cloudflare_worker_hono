import 'package:task_craft/module/user/domain/repositories/i_user_repository.dart';

class GetUserMe {
  late final IUserRepository _repository;

  GetUserMe({required IUserRepository userRepository}) {
    _repository = userRepository;
  }

   call() async {
    return _repository.getUserMe();
  }
}
