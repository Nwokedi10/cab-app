import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../src_barrel.dart';

class DriverTile extends StatelessWidget {
  const DriverTile({
    Key? key,
    required this.driver,
    this.isPhone = false,
  }) : super(key: key);

  final Driver driver;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Ui.width(context),
      height: 100,
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: Ui.backgroundImage(driver.image),
        ),
        title: AppText.thin(driver.fullName),
        subtitle: isPhone
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.thin(driver.phone, color: AppColors.accentColor),
                  Row(
                    children: [
                      AppText.medium(
                        "Call Driver",
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () async {
                            await launchUrl(
                                Uri(scheme: 'tel', path: driver.phone));
                          },
                          icon: Icon(
                            IconlyLight.arrow_right_2,
                            color: AppColors.accentColor,
                          ))
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.thin(driver.rating.toString(),
                      color: AppColors.accentColor),
                  AppText.thin("stars",
                      color: AppColors.accentColor, fontSize: 12),
                ],
              ),
      ),
    );
  }
}
