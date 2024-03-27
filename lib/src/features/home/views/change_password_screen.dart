import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:udrive/src/features/home/controllers/password_controller.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../global/ui/ui_barrel.dart';
import '../../../global/ui/widgets/fields/custom_textfield.dart';
import '../../../src_barrel.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final controller = Get.find<PasswordController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Change Password",
      child: Obx(() {
        return Ui.padding(
            child: controller.currentScreen.value == 0
                ? VerifyCodePasswordScreen()
                : ChangePassword());
      }),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final controller = Get.find<PasswordController>();
  String? oldPass;

  @override
  void initState() {
    controller.textEditingController[0].addListener(() {
      setState(() {
        oldPass = controller.textEditingController[0].value.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField.password(
            "New Password",
            controller.textEditingController[0],
          ),
          CustomTextField.password(
            "Confirm New Password",
            controller.textEditingController[1],
            oldPass: oldPass,
          ),
          const Spacer(),
          FilledButton(
            onPressed: () async {
              controller.resetPassword();
            },
            text: "Reset Password",
          )
        ],
      ),
    );
  }
}

class VerifyCodePasswordScreen extends StatefulWidget {
  const VerifyCodePasswordScreen({Key? key}) : super(key: key);

  @override
  State<VerifyCodePasswordScreen> createState() =>
      _VerifyCodePasswordScreenState();
}

class _VerifyCodePasswordScreenState extends State<VerifyCodePasswordScreen>
    with AutomaticKeepAliveClientMixin {
  bool isVerifying = false;
  bool keepAlive = true;
  final controller = Get.find<PasswordController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: SafeArea(
          child: Ui.padding(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Ui.boxHeight(120),
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
              final c = await HttpService.getPasswordToken(
                  pin, MyPrefs.localUser().email);
              controller.resetToken.value = c;
              setState(() {
                isVerifying = false;
              });
              if (c != "") {
                controller.changeScreen();
              }
            },
          ),
          Ui.boxHeight(96),
          AppText.thin(
              "Enter the 6 digit code that was sent to the phone registered with this email",
              alignment: TextAlign.center),
          Ui.boxHeight(32),
          isVerifying ? buildProgress() : const SizedBox(),
          Ui.boxHeight(96),
          GestureDetector(
            onTap: () async {
              controller.otpController.clear();
              // final c = await HttpService.sendotp(widget.email);
              setState(() {
                isVerifying = false;
              });
              // final c = await HttpService.getPasswordToken(pin);
            },
            child: const Text(
              "Didn't receive the code ? Resend OTP",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.underline,
                  color: Colors.white),
            ),
          ),
        ]),
      )),
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
