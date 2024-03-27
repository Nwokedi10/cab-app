import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udrive/src/features/home/views/widgets/wallet_verif_dropdown.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';

import '../../../../global/ui/widgets/others/containers.dart';
import '../../../../src_barrel.dart';
import '../../controllers/wallet_controller.dart';

class WalletVerifPage extends StatelessWidget {
  WalletVerifPage({super.key});
  final controller = Get.find<WalletController>();
  final ImagePicker _picker = ImagePicker();
  XFile? finalImage;

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Udrive Wallet",
      safeArea: true,
      child: Ui.padding(
        child: Column(children: [
          SizedText.thin(
              "Setup your udrive wallet to store cash within the app or make crypto payments."),
          Ui.boxHeight(24),
          IDWalletDropDown(),
          Ui.boxHeight(24),
          Obx(() {
            return GestureDetector(
              onTap: () async {
                await buildCamPicker();
              },
              child: controller.userIDCard.value.isNotEmpty
                  ? CurvedContainer(
                      radius: 21,
                      width: Ui.width(context) - 48,
                      child: UniversalImage(
                        controller.userIDCard.value,
                        width: Ui.width(context) - 48,
                      ),
                    )
                  : DottedBorder(
                      radius: Radius.circular(21),
                      dashPattern: const [4, 4],
                      borderType: BorderType.RRect,
                      color: Color(0xFFF5F5F5).withOpacity(0.4),
                      child: SizedBox(
                        width: Ui.width(context) - 48,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Ui.boxHeight(64),
                            Icon(
                              IconlyBold.image,
                              color: AppColors.accentColor,
                              size: 64,
                            ),
                            Ui.boxHeight(24),
                            AppText.thin("Upload ID Card",
                                color: AppColors.white.withOpacity(0.4)),
                            Ui.boxHeight(24)
                          ],
                        ),
                      )),
            );
          }),
          const Spacer(),
          FilledButton.white(controller.validateIDcard, "Upload ID")
        ]),
      ),
    );
  }

  buildCamPicker() async {
    finalImage = await _picker.pickImage(source: ImageSource.gallery);

    CroppedFile? file = await ImageCropper().cropImage(
      sourcePath: finalImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.52, ratioY: 1),
      // compressQuality: 100,
      maxHeight: 512,
      maxWidth: 337,
      compressFormat: ImageCompressFormat.png,
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        IOSUiSettings(
          title: "Adjust Size",
        ),
        AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "Adjust Size",
        ),
      ],
    );

    // int a = File(file!.path).lengthSync();

    // int kb = a ~/ 1024;
    String filepath = file!.path;

    // if (kb >= 5000) {
    //   ImageProperties properties =
    //       await FlutterNativeImage.getImageProperties(filepath);
    //   File compressedFile = await FlutterNativeImage.compressImage(filepath,
    //       quality: 80, targetWidth: 144, targetHeight: 144);
    //   filepath = compressedFile.path;
    // }

    controller.changeUserIDCard(filepath);
  }
}
