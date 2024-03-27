import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(),
      body: Ui.padding(
        child: SafeArea(
          child: Column(
            children: [
              Ui.align(child: AppText.medium("Privacy Settings", fontSize: 28)),
              Ui.boxHeight(64),
              SizedBox(
                width: Ui.width(context) - 48,
                child: AppText.thin(
                    "As part of our policy, we record video and audio for each trip to ensure the safety of our users.\n\nYou can choose the opt-in or out anytime as an option."),
              ),
              Ui.padding(
                padding: 24,
                child: Row(
                  children: List.generate(
                      PrivacyItems.values.length,
                      (index) => Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: item(PrivacyItems.values[index]),
                          ))),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Get.to(HomeScreen());
                },
                text: "Save Settings",
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget item(PrivacyItems pi) {
    bool isOn = false;
    return CurvedContainer(
      radius: 8,
      color: pi.color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.thin(pi.name),
              Icon(
                pi.icon,
                size: 36,
                color: pi.color == AppColors.secondaryColor
                    ? AppColors.accentColor
                    : AppColors.primaryColor,
              ),
              Switch(
                  thumbColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return AppColors.accentColor;
                  }),
                  activeTrackColor: AppColors.accentColor,
                  inactiveTrackColor: AppColors.primaryColor,
                  value: isOn,
                  onChanged: (val) {
                    setState(() {
                      isOn = val;
                    });
                  }),
              AppText.thin(isOn ? "ON" : "OFF", fontSize: 14)
            ],
          );
        }),
      ),
    );
  }
}
