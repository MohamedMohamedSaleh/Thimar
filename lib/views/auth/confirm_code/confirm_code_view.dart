import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vegetable_orders_project/core/widgets/custom_bottom_navigation.dart';
import 'package:vegetable_orders_project/core/widgets/custom_circle_or_button.dart';
import 'package:vegetable_orders_project/core/widgets/custom_fill_button.dart';
import 'package:vegetable_orders_project/core/widgets/custom_intoduction.dart';
import 'package:vegetable_orders_project/views/auth/change_password/bloc/change_password_bloc.dart';
import 'package:vegetable_orders_project/views/auth/confirm_code/bloc/confirm_bloc.dart';
import '../../../core/logic/helper_methods.dart';
import '../login/login_view.dart';

class ConfirmCodeView extends StatefulWidget {
  const ConfirmCodeView(
      {super.key, required this.isActive, required this.phone});

  final bool isActive;
  final String phone;
  @override
  State<ConfirmCodeView> createState() => _ConfirmCodeViewState();
}

class _ConfirmCodeViewState extends State<ConfirmCodeView> {
  final confirmBloc = KiwiContainer().resolve<ConfirmBloc>();
  final changePasswordBloc = KiwiContainer().resolve<ChangePasswordBloc>();

  @override
  void initState() {
    super.initState();
  }

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
                padding: EdgeInsets.only(
                  right: 16.w,
                  left: 16.w,
                ),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 15).r,
                  children: [
                    CustomIntroduction(
                      mainText: !widget.isActive
                          ? "نسيت كلمة المرور"
                          : "تفعيل الحساب",
                      supText:
                          "أدخل الكود المكون من 4 أرقام المرسل علي رقم الجوال",
                      isRequirPhoneCheck: true,
                    ),
                    PinCodeTextField(
                      controller: widget.isActive
                          ? confirmBloc.confirmCodeController
                          : changePasswordBloc.confirmCodeController,
                      appContext: context,
                      length: 4,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(15).w,
                        fieldHeight: 50.h,
                        fieldWidth: 60.w,
                        selectedColor: Theme.of(context).primaryColor,
                        inactiveColor: const Color(0xffF3F3F3),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    widget.isActive
                        ? BlocBuilder(
                            bloc: confirmBloc,
                            builder: (context, state) {
                              return CustomFillButton(
                                isLoading: state is ConfirmloadingState,
                                title: "تأكيد الكود",
                                onPress: () {
                                  confirmBloc
                                      .add(ConfirmEvent(phone: widget.phone));
                                },
                              );
                            },
                          )
                        : BlocBuilder(
                            bloc: changePasswordBloc,
                            builder: (context, state) {
                              return CustomFillButton(
                                isLoading: state is CheckCodeLoadingState,
                                title: "تأكيد الكود",
                                onPress: () {
                                  changePasswordBloc
                                      .add(CheckCodeEvent(phone: widget.phone));
                                },
                              );
                            },
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "لم تستلم الكود ؟\nيمكنك إعادة إرسال الكود بعد",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const CustomCircleOrButton(),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              text: "لديك حساب بالفعل ؟ ",
              buttonText: "تسجيل الدخول",
              onPress: () {
                navigateTo(toPage: const LoginView());
              },
            ),
          ),
        ],
      ),
    );
  }
}
