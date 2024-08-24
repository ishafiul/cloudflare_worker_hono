import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:task_craft/app/app_router.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';
import 'package:task_craft/core/widgets/spinner/fade_dots.dart';
import 'package:task_craft/module/user/domain/cubit/user_me/user_me_cubit.dart';

class VerifyOtpScreen extends HookWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isButtonActive = useState(true);
    final otpText = useState('');
    Widget loadingButon() {
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

    Widget regularButon() {
      return Padding(
        padding: 24.paddingHorizontal(),
        child: Button.primary(
          fill: ButtonFill.solid,
          shape: ButtonShape.rectangular,
          buttonSize: ButtonSize.large,
          isBlock: true,
          onPressed: isButtonActive.value
              ? () {
                 /* if (otpText.value.length == 5) {
                    FocusManager.instance.primaryFocus?.unfocus();

                    final email = context.read<RequestOtpCubit>().state
                            is RequestOtpSuccess
                        ? (context.read<RequestOtpCubit>().state
                                as RequestOtpSuccess)
                            .email
                        : null;

                    final deviceUuid = context.read<RequestOtpCubit>().state
                            is RequestOtpSuccess
                        ? (context.read<RequestOtpCubit>().state
                                as RequestOtpSuccess)
                            .deviceUuid
                        : null;

                    final userId = context.read<RequestOtpCubit>().state
                            is RequestOtpSuccess
                        ? (context.read<RequestOtpCubit>().state
                                as RequestOtpSuccess)
                            .userId
                        : null;

                    context.read<VerifyOtpCubit>().verifyOtp(
                          otp: int.parse(otpText.value),
                          email: email!,
                          deviceUuid: deviceUuid!,
                          userId: userId!,
                        );
                  }*/
                }
              : null,
          child: const Text("Continue"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm your number"),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          color: CColor.backgroundColor,
          padding: const EdgeInsets.only(top: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SafeArea(
                  child: BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
                    listener: (context, state) async {
                      if (state is VerifyOtpSuccess) {
                        router.go('/');
                        await context.read<UserMeCubit>().getUserMe();
                      }
                    },
                    builder: (context, state) {
                      if (state is VerifyOtpLoading) {
                        return loadingButon();
                      }
                      return regularButon();
                    },
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          16.verticalSpace,
          /*Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              child: BlocBuilder<RequestOtpCubit, RequestOtpState>(
                builder: (context, state) {
                  if (state is RequestOtpSuccess) {
                    return RichText(
                      text: TextSpan(
                        text: "Please enter the verification code sent to ",
                        style: context.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: state.email,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),*/
          16.verticalSpace,
          Padding(
            padding: 24.paddingHorizontal(),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Pinput(
                    length: 5,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(30, 60, 87, 1),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        color: CColor.backgroundColor,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(234, 239, 243, 1),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    validator: (s) {
                      if (s!.length != 5) {
                        return 'Pin is invalid';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length <= 4) {
                        isButtonActive.value = false;
                      } else {
                        isButtonActive.value = true;
                      }
                    },
                    errorTextStyle: const TextStyle(
                      color: Color(0xFFFF3141),
                      fontSize: 13,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w400,
                    ),
                    onCompleted: (pin) {
                      otpText.value = pin;
                    },
                  ),
                ],
              ),
            ),
          ),
          24.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Have not received the code?",
              ),
              Button.primary(
                onPressed: isButtonActive.value ? () {} : null,
                fill: ButtonFill.none,
                shape: ButtonShape.rectangular,
                buttonSize: ButtonSize.small,
                child: const Text("Resend code"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
