import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../controllers/settings_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final b = Ui.width(context) / 2;
    return SinglePageScaffold(
      title: "Edit Profile",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                buildUserPhoto(b),
                Ui.boxHeight(24),
                CustomTextField(
                  "John Doe",
                  "Name",
                  controller.textEditingController[0],
                  readOnly: true,
                  onTap: () {
                    Ui.showSnackBar(
                      "You have to contact customer care to update this field",
                    );
                  },
                  suffix: IconlyLight.edit,
                ),
                CustomTextField(
                  "0807 986 7865",
                  "Phone Number",
                  controller.textEditingController[1],
                  suffix: IconlyLight.edit,
                  readOnly: true,
                  onTap: () {
                    Ui.showSnackBar(
                      "You have to contact customer care to update this field",
                    );
                  },
                  varl: FPL.phone,
                ),
                Ui.boxHeight(48),
                MyPrefs.readData(MyPrefs.mpLogin3rdParty)
                    ? SizedBox()
                    : FilledButton(
                        onPressed: () async {
                          await controller.saveChanges();
                        },
                        text: "Upload Profile",
                      ),
                Ui.boxHeight(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildUserPhoto(double b) {
    return badgeBox(
        GestureDetector(
          onTap: () {
            // Get.to(ViewProfPicPage());
          },
          child: Container(
            width: b,
            height: b,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Obx(() {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: controller.userImage.value.isEmpty
                    ? Center(
                        child: Icon(IconlyLight.profile,
                            size: 80, color: AppColors.secondaryColor),
                      )
                    : controller.userImage.value.startsWith("http")
                        ? CachedNetworkImage(
                            imageUrl: controller.userImage.value,
                            width: b - 16,
                            height: b - 16,
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: (b - 16) / 2,
                              );
                            },
                            placeholder: (context, url) {
                              return TweenAnimationBuilder(
                                tween: ColorTween(
                                    begin: AppColors.primaryColor,
                                    end: AppColors.accentColor),
                                duration: Duration(seconds: 5),
                                builder: (context, value, child) {
                                  return Center(
                                    child: Icon(IconlyLight.profile,
                                        size: 80, color: value),
                                  );
                                },
                              );
                            },
                            errorWidget: (_, __, ___) {
                              return const Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Icon(IconlyLight.profile,
                                      size: 80, color: AppColors.red));
                            })
                        : controller.userImage.value.startsWith("assets")
                            ? Image.asset(controller.userImage.value)
                            : Image.file(File(controller.userImage.value)),
              );
            }),
          ),
        ), onTap: () async {
      await Get.bottomSheet(ChooseCam());
    }, shdShow: !MyPrefs.readData(MyPrefs.mpLogin3rdParty));
  }
}
