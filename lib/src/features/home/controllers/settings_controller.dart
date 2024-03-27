import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/registration/views/verify_code_screen.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';

import '../../../global/ui/ui_barrel.dart';

class SettingsController extends GetxController {
  List<TextEditingController> textEditingController =
      List.generate(2, (index) => TextEditingController());
  final formKey = GlobalKey<FormState>();

  RxString userImage = "".obs;

  @override
  onInit() {
    textEditingController[0].text = MyPrefs.localUser().fullName;
    textEditingController[1].text = MyPrefs.localUser().phone;
    userImage.value = MyPrefs.localUser().image;
    MyPrefs.listenToPrefChanges(MyPrefs.mpFirstName, (value) {
      textEditingController[0].text = MyPrefs.localUser().fullName;
    });
    MyPrefs.listenToPrefChanges(MyPrefs.mpLoggedInPhone, (value) {
      textEditingController[1].text = value ?? "";
    });
    MyPrefs.listenToPrefChanges(MyPrefs.mpLoggedInURLPhoto, (value) {
      userImage.value = value ?? "";
    });

    super.onInit();
  }

  saveChanges() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      if (!userImage.value.startsWith("http") && userImage.value.isNotEmpty) {
        await HttpService.uploadImage(userImage.value);
      }
      // final h = await HttpService.updateUser(MyPrefs.localUser().id,
      //     textEditingController[0].text, textEditingController[1].text);
      // if (h) {
      //   Get.to(VerifyCodeScreen(nextScreen: HomeScreen()));
      // } else {
      //   Ui.showSnackBar("Something bad happened");
      // }
    }
  }

  changeUserImage(String file) {
    userImage.value = file;
  }
}
