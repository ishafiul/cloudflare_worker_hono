import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_craft/app/app_router.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';
import 'package:task_craft/core/service/local/app_state.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/devider/divider.dart';
import 'package:task_craft/core/widgets/devider/text_divider.dart';
import 'package:task_craft/core/widgets/shimmer.dart';
import 'package:task_craft/module/user/domain/cubit/user_me/user_me_cubit.dart';

class MenuScreen extends HookWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = useState(false);
    _animate() async {
      await AppStateService()
          .isLoggedIn()
          .then((value) => isLoggedIn.value = value);
    }

    useEffect(() {
      _animate();
      return null;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CustomIcons.more),
          ),
        ],
      ),
      body: ListView(
        children: [
          20.verticalSpace,
          CDivider.text(
            text: "Profile",
            position: TextDividerPosition.left,
          ),
          8.verticalSpace,
          Padding(
            padding: 20.paddingHorizontal(),
            child: AppShimmer(
              isLoading: isLoggedIn.value,
              child: Visibility(
                visible: !isLoggedIn.value,
                child: ListTile(
                  onTap: () {
                    router.push('/auth/login');
                  },
                  leading: const Icon(CustomIcons.user),
                  title: const Text("Login"),
                  subtitle: const Text("You are not logged in. Login now"),
                ),
              ),
            ),
          ),
          if (!isLoggedIn.value) 4.verticalSpace,
          Padding(
            padding: 20.paddingHorizontal(),
            child: BlocBuilder<UserMeCubit, UserMeState>(
              builder: (context, state) {
                if (state is UserMeLoaded) {
                  return AppShimmer(
                    isLoading: isLoggedIn.value,
                    child: ListTile(
                      onTap: () {},
                      leading: const Icon(CustomIcons.user),
                      title: state.userMe != null &&
                              state.userMe!.firstName != null &&
                              state.userMe!.lastName != null
                          ? Text(
                              "${state.userMe?.firstName} ${state.userMe?.lastName}",
                            )
                          : null,
                      subtitle: Text("${state.userMe?.email}"),
                    ),
                  );
                }
                if (state is UserMeLoading) {
                  return const AppShimmer(
                    isLoading: false,
                    child: SizedBox(),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          4.verticalSpace,
         /* BlocBuilder<LogoutCubit, LogoutState>(
            builder: (context, state) {
              return Opacity(
                opacity: state is LogoutLoading ? 0.4 : 1,
                child: Padding(
                  padding: 20.paddingHorizontal(),
                  child: AppShimmer(
                    isLoading: isLoggedIn.value,
                    child: ListTile(
                      onTap: state is LogoutLoading
                          ? null
                          : () {
                              context.read<LogoutCubit>().logout();
                            },
                      leading: const Icon(CustomIcons.logout),
                      title: state is LogoutLoading
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FadingFourSpinner(
                                  color: CColor.text,
                                  size: 20,
                                ),
                                8.horizontalSpace,
                                const Text("Logout Loading"),
                              ],
                            )
                          : const Text("Logout"),
                    ),
                  ),
                ),
              );
            },
          ),*/
        ],
      ),
    );
  }
}
