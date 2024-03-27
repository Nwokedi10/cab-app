import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';

import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/registration/views/login_screen.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/button/outlined_button.dart';

import '../../src_barrel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  double imgBottom = 48;
  bool nextPage = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() {
      if (mounted) {
        setState(() {
          imgBottom = 48 + (_animationController.value * 52);
        });
      }
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            nextPage = true;
          });
        }
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox.expand(),
          Positioned(
              bottom: imgBottom,
              child: Image.asset(
                Assets.ss1,
                width: Ui.width(context),
              )),
          nextPage
              ? SafeArea(
                  child: Ui.padding(
                    padding: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ui.boxHeight((Ui.height(context) * 0.2) - 32),
                        AppText.medium("Transparency in", fontSize: 36),
                        AppText.bold("Transportation",
                            color: AppColors.accentColor, fontSize: 36),
                        Ui.boxHeight(8),
                        AppText.thin(
                            "Get to your Destination safely, without hassles"),
                        const Spacer(),
                        FilledButton.outline(() {
                          Get.to(LoginScreen());
                        }, "Login")
                      ],
                    ),
                  ),
                )
              : Positioned(
                  left: 48,
                  right: 48,
                  top: _animationController.value * 72,
                  bottom: 0,
                  child: Opacity(
                    opacity: 1 - _animationController.value,
                    child: SizedBox(
                      width: Ui.width(context) * 0.66,
                      child: Image.asset(
                        Assets.logo,
                        width: Ui.width(context) * 0.66,
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
