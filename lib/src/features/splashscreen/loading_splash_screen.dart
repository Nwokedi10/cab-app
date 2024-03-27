import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:udrive/src/features/splashscreen/splash_screen.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';

import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/registration/views/login_screen.dart';
import 'package:udrive/src/global/services/mypref.dart';

import '../../src_barrel.dart';

class LoadingSplashScreen extends StatefulWidget {
  const LoadingSplashScreen({super.key});

  @override
  State<LoadingSplashScreen> createState() => _LoadingSplashScreenState();
}

class _LoadingSplashScreenState extends State<LoadingSplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (mounted) {
        await MyPrefs.injectDependencies();
        Widget hscreen = const SplashScreen();
        if (MyPrefs.hasOpened()) {
          final d = await MyPrefs.isLoggedIn();
          if (d) {
            final c = await MyPrefs.getUpdatedUser();
            if (c) {
              hscreen = const HomeScreen();
            } else {
              hscreen = const LoginScreen();
            }
          } else {
            hscreen = const LoginScreen();
          }
        }
        Get.to(hscreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleAnimWidget(
          d: const Duration(seconds: 1),
          child: Image.asset(
            Assets.logo,
            width: Ui.width(context) * 0.66,
          ),
        ),
      ),
    );
  }

  // @override
  // Future<void> dispose() async {
  //   super.dispose();
  //   final d = await MyPrefs.isLoggedIn();
  //   if (!d) {
  //     await MyPrefs.logout();
  //   }
  // }
}
