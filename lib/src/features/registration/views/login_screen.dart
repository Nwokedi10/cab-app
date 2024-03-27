import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/registration/controllers/registration_controller.dart';
import 'package:udrive/src/features/registration/views/add_email_screen.dart';
import 'package:udrive/src/features/registration/views/widgets/login_header.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';

import '../../../src_barrel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.find<RegistrationController>();
  String? oldPass;

  @override
  void initState() {
    controller.textControllers[4].addListener(() {
      if (mounted) {
        setState(() {
          oldPass = controller.textControllers[4].value.text;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // controller.formkey = GlobalKey<FormState>();
    // print("object disposed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Ui.padding(
            child: Form(
              key: controller.formkey,
              child: Obx(() {
                return Column(children: [
                  Ui.boxHeight(56),
                  LoginHeader(),
                  Ui.boxHeight(24),
                  if (controller.isLogin)
                    CustomTextField("kene@gmail.com", "Email",
                        controller.textControllers[0],
                        varl: FPL.email),
                  if (controller.isLogin)
                    CustomTextField(
                        "********", "Password", controller.textControllers[1],
                        varl: FPL.password),
                  if (!controller.isLogin)
                    CustomTextField(
                        "Kene Nwachukwu", "Name", controller.textControllers[2],
                        varl: FPL.text),
                  if (!controller.isLogin)
                    CustomTextField("kene@gmail.com", "Email",
                        controller.textControllers[3],
                        varl: FPL.email),
                  if (!controller.isLogin)
                    CustomTextField(
                        "Enter referral code",
                        "Referral Code (Optional)",
                        controller.textControllers[9],
                        shdValidate: false,
                        varl: FPL.text),
                  if (!controller.isLogin)
                    CustomTextField.password(
                        "Password", controller.textControllers[4],
                        tia: TextInputAction.next),
                  if (!controller.isLogin)
                    CustomTextField.password(
                      "Confirm Password",
                      controller.textControllers[5],
                      oldPass: oldPass,
                    ),
                  Ui.boxHeight(24),
                  FilledButton.white(() async {
                    await controller.loginBtnOnPressed();
                  }, controller.loginStates[controller.loginState.value]),
                  if (controller.isLogin) Ui.boxHeight(24),
                  if (controller.isLogin)
                    GestureDetector(
                      onTap: () {
                        Get.to(AddEmailScreen());
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  Ui.boxHeight(32),
                  AppText.thin(controller.isLogin
                      ? "Or Continue With"
                      : "Or SignUp With"),
                  Ui.boxHeight(14),
                  const SocialButtonContainer(),
                ]);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
