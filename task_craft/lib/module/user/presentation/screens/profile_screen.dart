import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_craft/module/user/domain/cubit/user_me/user_me_cubit.dart';

class MenuScreen extends HookWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        context.read<UserMeCubit>().syncUserMe();
        return null;
      },
      [],
    );
    return const Placeholder();
  }
}
