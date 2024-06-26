import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:vegetable_orders_project/core/widgets/custom_app_input.dart';
import 'package:vegetable_orders_project/core/widgets/custom_bottom_navigation.dart';
import 'package:vegetable_orders_project/core/widgets/custom_fill_button.dart';
import 'package:vegetable_orders_project/core/widgets/custom_intoduction.dart';
import 'package:vegetable_orders_project/views/auth/login/bloc/login_bloc.dart';

import '../../../core/logic/helper_methods.dart';
import '../forget_password/forget_password_view.dart';
import '../register/register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/splash_bg.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                ).r,
                child: const FormLogin(),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              text: "ليس لديك حساب ؟",
              buttonText: " تسجيل الأن",
              paddingBottom: 22.h,
              onPress: () {
                navigateTo(toPage: const RegisterView());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({
    super.key,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final bloc = KiwiContainer().resolve<LoginBloc>();

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: bloc.formKey,
      autovalidateMode: bloc.autovalidateMode,
      child: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          CustomIntroduction(
            mainText: "مرحبا بك مرة أخرى",
            supText: "يمكنك تسجيل الدخول الأن",
            paddingHeight: 28.h,
          ),
          CustomAppInput(
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "رقم الجوال مطلوب";
              } else if (value!.length < 10) {
                return "رقم الهاتف يجب أن يكون أكبر من 10 أرقام";
              }
              return null;
            },
            labelText: "رقم الجوال",
            prefixIcon: "assets/icon/phone_icon.png",
            isPhone: true,
            controller: bloc.phoneController,
          ),
          CustomAppInput(
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "كلمة المرور مطلوبه";
              } else if (value!.length < 6) {
                return "كلمة المرور يجب أن تكون أكبر من 5 أحرف";
              }
              return null;
            },
            controller: bloc.passwordController,
            labelText: "كلمة المرور",
            prefixIcon: "assets/icon/lock_icon.png",
            isPassword: true,
            paddingBottom: 0,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              child: Text(
                "نسيت كلمة المرور ؟",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    height: .1,
                    color: Colors.black),
              ),
              onPressed: () {
                navigateTo(toPage: const ForgetPasswordView());
              },
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              return CustomFillButton(
                isLoading: state is LoginLoadingState,
                title: "تسجيل الدخول",
                onPress: () {
                  bloc.add(LoginEvent());
                },
              );
            },
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
