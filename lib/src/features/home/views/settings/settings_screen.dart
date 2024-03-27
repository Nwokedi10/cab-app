import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/settings_controller.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/features/registration/views/login_screen.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../change_password_screen.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> options = [
    "Edit Profile",
    "Change Password",
    "Change Home Location",
    "Log Out"
  ];

  List<Widget?> screens = [
    EditProfileScreen(),
    ChangePasswordScreen(),
    MapWidget(
      isSearch: true,
    ),
    null
  ];
  final controller = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    controller.userImage.value = MyPrefs.localUser().image;
    if (MyPrefs.readData(MyPrefs.mpLogin3rdParty)) {
      options.removeAt(1);
      screens.removeAt(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Settings",
      child: Ui.padding(
          child: ListView.separated(
        itemBuilder: (_, i) {
          final screen = screens[i];
          return ListTile(
            leading: AppText.thin(options[i], color: AppColors.accentColor),
            trailing: Icon(
              IconlyLight.arrow_right_2,
              color: AppColors.accentColor,
            ),
            onTap: () {
              if (screen != null) {
                Get.to(screen);
              } else {
                Ui.showBottomSheet(
                  "Logout",
                  "Are you sure you want to Log out of your account?",
                  LoginScreen(),
                  yesBtn: () async {
                    await HttpService.logout();
                  },
                );
              }
            },
          );
        },
        itemCount: options.length,
        separatorBuilder: (_, i) =>
            Divider(color: AppColors.white.withOpacity(0.1)),
      )),
    );
  }
}
