import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_craft/app/app_router.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';
import 'package:task_craft/core/widgets/devider/divider.dart';
import 'package:task_craft/core/widgets/input.dart';
import 'package:task_craft/core/widgets/snackbar.dart';
import 'package:task_craft/core/widgets/spinner/fade_dots.dart';
import 'package:task_craft/module/auth/presentation/widgets/social_buttons.dart';

final _loginFormKey = GlobalKey<FormState>();

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isButtonActive = useState(true);
    final emailController = useState('');

    Widget loadingButton() {
      return Padding(
        padding: 24.paddingHorizontal(),
        child: Button.primary(
          fill: ButtonFill.solid,
          shape: ButtonShape.rectangular,
          buttonSize: ButtonSize.large,
          isBlock: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FadingFourSpinner(
                color: Colors.white,
                size: 20,
              ),
              8.horizontalSpace,
              const Text("Loading"),
            ],
          ),
        ),
      );
    }

    Widget regularButton() {
      return Padding(
        padding: 24.paddingHorizontal(),
        child: Button.primary(
          fill: ButtonFill.solid,
          shape: ButtonShape.rectangular,
          buttonSize: ButtonSize.large,
          isBlock: true,
          onPressed: isButtonActive.value
              ? () {
                  if (_loginFormKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                   /* context
                        .read<RequestOtpCubit>()
                        .requestOtp(email: emailController.value);*/
                  } else {
                    isButtonActive.value = false;
                  }
                }
              : null,
          child: const Text("Continue"),
        ),
      );
    }

    useEffect(
      () {
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Craft"),
        centerTitle: false,
        actions: [
          Button.primary(
            child: const Text("Skip For Now"),
            onPressed: () {
              router.go('/');
            },
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _loginFormKey,
          child: ListView(
            children: [
              16.verticalSpace,
              Padding(
                padding: 24.paddingHorizontal(),
                child: Text(
                  "Login or Sign Up to get started.",
                  style: context.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              16.verticalSpace,
              Padding(
                padding: 24.paddingHorizontal(),
                child: TextInputField(
                  placeholder: "ex: shafiulislam20@gmail.com",
                  disabled: false,
                  isRequired: true,
                  labelText: "Email",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    if (value.isMail != true) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (!_loginFormKey.currentState!.validate()) {
                      isButtonActive.value = false;
                    } else {
                      isButtonActive.value = true;
                    }
                    emailController.value = value;
                  },
                ),
              ),
              8.verticalSpace,
              Padding(
                padding: 24.paddingHorizontal(),
                child: Text(
                  "We will send you an OTP on your registered email address.",
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              4.verticalSpace,
              16.verticalSpace,
              /*BlocConsumer<RequestOtpCubit, RequestOtpState>(
                listener: (context, state) {
                  if (state is RequestOtpSuccess) {
                    router.push('/auth/verify-otp');
                  }
                  if (state is RequestOtpFailure) {
                    showSnackBar(
                      message: state.message,
                      type: SnackBarType.error,
                      withIcon: true,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is RequestOtpLoading) {
                    return loadingButton();
                  }
                  return regularButton();
                },
              ),*/
              16.verticalSpace,
              Padding(
                padding: 24.paddingHorizontal(),
                child: CDivider.text(text: "or"),
              ),
              16.verticalSpace,
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
