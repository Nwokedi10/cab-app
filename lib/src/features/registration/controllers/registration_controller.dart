import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:udrive/src/features/home/views/change_password_screen.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/registration/views/add_phone_screen.dart';
import 'package:udrive/src/features/registration/views/verify_code_screen.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/src_barrel.dart';

class RegistrationController extends GetxController {
  /// TextEditingControllers
  /// 1 - Login Email
  /// 2 - Login Password
  /// 3 - SignUp Name
  /// 4 - SignUp Email
  /// 5 - SignUp Password
  /// 6 - SignUp Confirm Password
  /// 7 - Verify Phone
  /// 8 - Email FP
  /// 9 - Referral Code
  List<TextEditingController> textControllers =
      List.generate(10, (index) => TextEditingController());

  ///isLogin is used to check if the page is in the login or signup page
  RxInt loginState = 0.obs;
  final List<String> loginStates = ["Login", "Sign Up"];
  final formkey = GlobalKey<FormState>();
  final OtpFieldController otpController = OtpFieldController();

  final pformkey = GlobalKey<FormState>();
  final fpformkey = GlobalKey<FormState>();

  bool get isLogin => loginState.value == 0;

  resetData() {
    textControllers = List.generate(10, (index) => TextEditingController());
    loginState.value = 0;
  }

  _login() async {
    final form = formkey.currentState!;
    if (form.validate()) {
      final c = await HttpService.login(
          textControllers[0].value.text, textControllers[1].value.text);
      if (c) {
        UtilFunctions.clearTextEditingControllers(textControllers);
        Get.to(const HomeScreen());
      }
    }
  }

  _signUp() async {
    final form = formkey.currentState!;
    if (form.validate()) {
      final c = await HttpService.signUp(textControllers[2].value.text,
          textControllers[3].value.text, textControllers[4].value.text);
      if (c) {
        Get.to(AddPhoneScreen());
      }
    }
  }

  Future<void> loginBtnOnPressed() async {
    await MyPrefs.writeData(MyPrefs.mpLogin3rdParty, false);
    isLogin ? await _login() : await _signUp();
  }

  changeLoginState(int i) {
    loginState.value = i;
  }

  verifyPhone() async {
    final form = pformkey.currentState!;
    if (form.validate()) {
      final c = await HttpService.addPhone(textControllers[6].value.text);
      if (c) {
        Get.to(const VerifyCodeScreen());
      }
    }
  }

  validateOTP() {
    otpController.clear();
  }

  reset() {
    UtilFunctions.clearTextEditingControllers(textControllers);
    otpController.clear();
    loginState.value = 0;
  }

  forgotPassword() async {
    final form = fpformkey.currentState!;
    if (form.validate()) {
      await MyPrefs.saveEmail(textControllers[8].value.text);
      final c = await HttpService.forgotPassword(textControllers[8].value.text);
      if (c) {
        Get.to(ChangePasswordScreen());
      }
    }
  }
}
