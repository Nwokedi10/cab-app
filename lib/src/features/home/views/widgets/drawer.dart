import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/views/about_page.dart';
import 'package:udrive/src/features/home/views/customer_support_screen.dart';
import 'package:udrive/src/features/home/views/invite_friend_screen.dart';
import 'package:udrive/src/features/home/views/payment/payment_option_screen.dart';
import 'package:udrive/src/features/home/views/promo_screen.dart';
import 'package:udrive/src/features/home/views/ride_history_screen.dart';
import 'package:udrive/src/features/home/views/settings/edit_profile_screen.dart';
import 'package:udrive/src/features/home/views/settings/settings_screen.dart';
import 'package:udrive/src/features/home/views/widgets/loading_screen.dart';
import 'package:udrive/src/features/registration/views/privacy_screen.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});
  final controller = Get.find<HomeController>();

  List<String> drawerItems = [
    "Ride History",
    "Payment Options",
    "Customer Care",
    // "Camera & Mic",
    "Invite Friends",
    "Promos",
    "Settings",
    "About"
  ];

  List<Widget> screens = [
    RideHistoryScreen(),
    PaymentOptionScreen(),
    CustomerSupportScreen(),
    // PrivacySettingsScreen(),
    InviteFriendScreen(),
    PromoScreen(),
    SettingsScreen(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Ui.width(context) - 84,
      padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      color: AppColors.primaryColor,
      child: Column(
        children: [
          Row(
            children: [
              AppText.medium(controller.currentUser.value.fullName,
                  fontSize: 20),
              const Spacer(),
              SvgIconButton(
                Assets.close,
                () {
                  Get.back();
                },
              )
            ],
          ),
          Row(
            children: [
              AppText.thin(controller.currentUser.value.phone,
                  color: AppColors.accentColor),
              Ui.boxWidth(24),
              // IconButton(
              //     onPressed: () {
              //       Get.to(EditProfileScreen());
              //     },
              //     icon: Icon(
              //       Icons.edit_rounded,
              //       color: AppColors.accentColor,
              //     ))
            ],
          ),
          Ui.boxHeight(32),
          ...List.generate(
              drawerItems.length,
              (index) => ListTile(
                    leading: AppText.thin(drawerItems[index]),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    onTap: () {
                      final screen = screens[index];
                      if (index == 2) {
                        Get.showOverlay(
                            asyncFunction: () async {
                              await FlutterWebBrowser.openWebPage(
                                url: "https://udrivecab.com/",
                                customTabsOptions: const CustomTabsOptions(
                                  colorScheme: CustomTabsColorScheme.dark,
                                  defaultColorSchemeParams:
                                      CustomTabsColorSchemeParams(
                                          toolbarColor: AppColors.primaryColor),
                                  shareState: CustomTabsShareState.on,
                                  instantAppsEnabled: true,
                                  showTitle: true,
                                  urlBarHidingEnabled: true,
                                ),
                                safariVCOptions:
                                    const SafariViewControllerOptions(
                                  barCollapsingEnabled: true,
                                  preferredBarTintColor: AppColors.primaryColor,
                                  dismissButtonStyle:
                                      SafariViewControllerDismissButtonStyle
                                          .close,
                                  modalPresentationCapturesStatusBarAppearance:
                                      true,
                                ),
                              );
                            },
                            opacity: 0.8,
                            loadingWidget: Center(child: CircularProgress(56)));
                      } else {
                        Get.to(screen);
                      }
                    },
                  ))
        ],
      ),
    );
  }
}
