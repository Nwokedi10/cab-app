import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});
  List<String> titles = ["Rate the App", "Udrive Terms", "Privacy Policy"];
  List<IconData> icons = [
    IconlyLight.star,
    IconlyLight.document,
    IconlyLight.shield_done
  ];

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "About",
      child: Ui.padding(
        child: Column(children: [
          Ui.align(
              child: AppText.thin("App Version 1.0.0+7",
                  color: AppColors.accentColor)),
          Ui.boxHeight(24),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, i) {
                return ListTile(
                  leading: Icon(
                    icons[i],
                    color: AppColors.accentColor,
                  ),
                  trailing: Icon(
                    IconlyLight.arrow_right_2,
                    color: AppColors.accentColor,
                  ),
                  onTap: () async {
                    if (i == 0) {
                      await launchUrl(Uri.parse("https://udrivecab.com"));
                    } else if (i == 1) {
                      await launchUrl(
                          Uri.parse("https://udrivecab.com/terms.html"));
                    } else {
                      await launchUrl(
                          Uri.parse("https://udrivecab.com/privacy.html"));
                    }
                  },
                  title: AppText.thin(titles[i]),
                );
              },
              itemCount: 3,
              separatorBuilder: (_, i) =>
                  Divider(color: AppColors.white.withOpacity(0.1)),
            ),
          )
        ]),
      ),
    );
  }
}
