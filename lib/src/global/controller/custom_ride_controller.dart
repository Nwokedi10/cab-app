import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';

abstract class CustomRideController extends GetxController {
  Rx<int> timeElapsed = 0.obs;
  Rx<int> totalTime = 10.obs;
  final homeController = Get.find<HomeController>();

  RxInt curScreen = 0.obs;
  final dragController = DraggableScrollableController();

  changeScreen(int a) {
    curScreen.value = a;
  }

  expand() {
    dragController.animateTo(1,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  reduce() {
    dragController.animateTo(0.12,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
