import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegetable_orders_project/core/logic/dio_helper.dart';
import 'package:vegetable_orders_project/core/logic/helper_methods.dart';
import 'package:vegetable_orders_project/views/auth/confirm_code/confirm_code_view.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvents, ForgetPasswordStates> {
  ForgetPasswordBloc() : super(ForgetPasswordInitial()) {
    on<ForgetPasswordEvent>(_sendData);
  }

  Future<void> _sendData(
      ForgetPasswordEvent event, Emitter<ForgetPasswordStates> emit) async {
    emit(ForgetPasswordLoading());
    final response =
        await DioHelper().sendData(endPoint: 'forget_password', data: {
      "phone": event.phone,
    });

    if (response.isSuccess) {
      emit(ForgetPasswordSuccess());
      if (!event.resend) {
        navigateTo(
            toPage: ConfirmCodeView(isActive: false, phone: event.phone));
      }
      await Future.delayed(const Duration(seconds: 3));

      showMessage(
          type: MessageType.success,
          message: "Your Confirm Code is '1111'",
          paddingBottom:
              MediaQuery.of(navigatorKey.currentContext!).size.height - 260,
          duration: 5);
    } else {
      emit(ForgetPasswordFailed());
      showMessage(message: response.message, type: MessageType.success);
    }
  }
}
