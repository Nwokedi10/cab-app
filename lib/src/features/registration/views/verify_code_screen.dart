import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/registration/controllers/registration_controller.dart';
import 'package:udrive/src/features/registration/views/privacy_screen.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';

import '../../../global/ui/ui_barrel.dart';

class VerifyCodeScreen extends StatefulWidget {
  final Widget? nextScreen;
  const VerifyCodeScreen({this.nextScreen, Key? key}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<RegistrationController>();
  bool isVerifying = false;
  bool keepAlive = true;
  bool isResent = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: backAppBar(),
      body: SizedBox(
        height: Ui.height(context),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Ui.padding(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Ui.boxHeight(8),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText.medium("Account \nVerification", fontSize: 28),
              ),
              Ui.boxHeight(96),
              OTPTextField(
                length: 6,
                controller: controller.otpController,
                width: Ui.width(context),
                fieldWidth: 40,
                style: const TextStyle(fontSize: 24, color: Colors.white),
                otpFieldStyle: OtpFieldStyle(
                  borderColor: Colors.white,
                  enabledBorderColor: Colors.white,
                ),
                onChanged: (val) {},
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) async {
                  setState(() {
                    keepAlive = false;
                    isVerifying = true;
                  });
                  // if (widget.screen == null) {
                  //   Get.off(ForgotPasswordPage(
                  //     isFFP: false,
                  //     email: widget.email,
                  //     code: pin,
                  //   ));
                  // } else {
                  //   final c = await HttpService.validateotp(pin, widget.email);
                  //   if (c) {
                  //     Get.off(widget.screen);
                  //   }
                  // }
                  final c = await HttpService.verifyPhone(pin);

                  controller.validateOTP();
                  bool d = false;
                  if (c) {
                    d = await HttpService.completeSignUp();
                  }

                  setState(() {
                    isVerifying = false;
                  });
                  if (d && c) {
                    Get.to(widget.nextScreen ?? HomeScreen());
                  }
                },
              ),
              Ui.boxHeight(96),
              AppText.thin(
                  "Enter the 6 digit code that was sent to your phone"),
              Ui.boxHeight(32),
              isVerifying ? buildProgress() : const SizedBox(),
              Ui.boxHeight(96),
              isResent
                  ? TimerText(
                      durationInMinutes: 1,
                      onTimerFinished: () {
                        setState(() {
                          isResent = false;
                        });
                      })
                  : InkWell(
                      onTap: () async {
                        controller.otpController.clear();
                        // final c = await HttpService.sendotp(widget.email);
                        setState(() {
                          isVerifying = false;
                        });
                        final c = await HttpService.addPhone(
                            MyPrefs.localUser().phone);
                        if (c) {
                          Ui.showSnackBar("Check your SMS messages",
                              isError: false);
                        }
                        // if (c) {
                      },
                      child: SizedBox(
                        height: 36,
                        width: Ui.width(context) * 0.9,
                        child: const Text(
                          "Didn't receive the code ? Resend OTP",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                        ),
                      ),
                    ),
            ]),
          )),
        ),
      ),
    );
  }

  buildProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        CircularProgress(
          54,
          primaryColor: Colors.white,
          secondaryColor: Colors.white10,
          strokeWidth: 10,
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          "Verifying...",
          style: TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
