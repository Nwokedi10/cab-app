import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/booking_controller.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/features/home/views/booking/bookinglist_screen.dart';
import 'package:udrive/src/features/home/views/current_location_screen.dart';
import 'package:udrive/src/features/home/views/regular_trips_screen.dart';
import 'package:udrive/src/features/home/views/settings/edit_profile_screen.dart';
import 'package:udrive/src/features/home/views/widgets/carousel_ad.dart';
import 'package:udrive/src/features/home/views/widgets/drawer.dart';
import 'package:udrive/src/features/home/views/widgets/home_tile.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/ui/ui_barrel.dart';
import 'invite_friend_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeController>();
  final rideController = Get.find<RideController>();
  final bookController = Get.find<BookingController>();
  final walletController = Get.find<WalletController>();

  // @override
  // void initState() {
  //   // if(mounted){
  //   //   walletController.getWalletBalance();
  //   //   controller.currentUser.value = MyPrefs.localUser();
  //   // }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HomeDrawer(),
      body: Stack(
        children: [
          Positioned(bottom: -92, right: -92, child: Ui.gradCircle()),
          Positioned(top: -92, left: -92, child: Ui.gradCircle()),
          SizedBox.expand(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Ui.padding(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(EditProfileScreen());
                            },
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor:
                                  const Color(0xFFF2F2F2).withOpacity(0.2),
                              child: Obx(() {
                                return controller
                                        .currentUser.value.image.isEmpty
                                    ? const Center(
                                        child: Icon(IconlyLight.profile,
                                            size: 48,
                                            color: AppColors.secondaryColor),
                                      )
                                    : CircleAvatar(
                                        radius: 24,
                                        backgroundColor: AppColors.transparent,
                                        backgroundImage: Ui.backgroundImage(
                                            controller.currentUser.value.image),
                                      );
                              }),
                            ),
                          ),
                          Ui.boxWidth(9),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.thin(
                                  "Hi ${UtilFunctions.formatFullName(controller.currentUser.value.firstName)}!"),
                              Ui.boxHeight(4),
                              CurvedContainer(
                                padding: const EdgeInsets.only(
                                    left: 8, top: 4, bottom: 4, right: 8),
                                child: Row(
                                  children: [
                                    AppText.thin("Wallet Balance:  ",
                                        color: AppColors.accentColor),
                                    Obx(() {
                                      return AppText.medium(
                                          walletController.totalBalance,
                                          fontFamily: "Roboto");
                                    })
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          Builder(builder: (context) {
                            return SvgIconButton(
                              Assets.menu,
                              () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              size: 32,
                            );
                          })
                        ],
                      ),
                      Ui.boxHeight(24),
                      CarouselSlider(),
                      HomeTile(
                        "Regular Trips",
                        onTap: () {
                          Get.to(RegularTripsScreen());
                        },
                        child: Obx(() {
                          return controller.userRegularTrips.isEmpty
                              ? SizedBox()
                              : Ui.align(
                                  align: Alignment.centerRight,
                                  child: LineTripTile(
                                    trip: Trip(),
                                  ));
                        }),
                      ),
                      HomeTile(
                        "Start Ride",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              VehicleTypes.values.length,
                              (index) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CurvedContainer(
                                        onPressed: () {
                                          // Ui.showSnackBar("Coming Soon",
                                          //     isError: false);
                                          // Get.to(controller.screens[index]);
                                          controller.currentVehicleType.value =
                                              VehicleTypes.values[index];
                                          Get.to(const CurrentLocationScreen());
                                        },
                                        color: AppColors.secondaryColor,
                                        radius: 18,
                                        child: SizedBox(
                                          height: 72,
                                          width: 72,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SvgPicture.asset(
                                              VehicleTypes
                                                  .values[index].homeIcons,
                                              width: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Ui.boxHeight(14),
                                      SizedBox(
                                          width: (Ui.width(context) / 3) - 48,
                                          child: AppText.thin(
                                              VehicleTypes.values[index].name,
                                              alignment: TextAlign.center))
                                    ],
                                  )),
                        ),
                      ),
                      Obx(() {
                        return WidgetOrNull(
                          bookController.allBooking.isNotEmpty,
                          child: HomeTile(
                            "Booking List",
                            onTap: () {
                              Get.to(BookingListScreen());
                            },
                          ),
                        );
                      }),
                      Ui.boxHeight(24),
                      GestureDetector(
                        onTap: () {
                          Get.to(InviteFriendScreen());
                        },
                        child: Stack(
                          children: [
                            Image.asset(Assets.referral,
                                width: Ui.width(context) - 48),
                            Positioned(
                                right: 24,
                                bottom: 24,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.white,
                                  radius: 20,
                                  child: Icon(
                                    IconlyLight.arrow_right_2,
                                    color: AppColors.primaryColor,
                                    size: 24,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      // CurvedContainer(
                      //     radius: 30,
                      //     width: Ui.width(context) - 48,
                      //     margin: EdgeInsets.symmetric(vertical: 24),
                      //     onPressed: () {
                      //       Get.to(InviteFriendScreen());
                      //     },
                      //     color: AppColors.secondaryColor,
                      //     image: Assets.referral,
                      //     padding: EdgeInsets.all(24),
                      //     child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           AppText.medium("Refer a friend"),
                      //           Ui.boxHeight(8),
                      //           AppText.thin("15%", fontSize: 48),
                      //           Ui.boxHeight(8),
                      //           Row(mainAxisSize: MainAxisSize.min, children: [
                      //             CurvedContainer(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     vertical: 4, horizontal: 16),
                      //                 color: AppColors.accentColor,
                      //                 child: AppText.thin("Off", fontSize: 16)),
                      //             Ui.boxWidth(10),
                      //             AppText.thin("your next ride")
                      //           ]),
                      //           Ui.align(
                      //               align: Alignment.centerRight,
                      //               child: CircleAvatar(
                      //                 backgroundColor: AppColors.white,
                      //                 radius: 20,
                      //                 child: Icon(
                      //                   IconlyLight.arrow_right_2,
                      //                   color: AppColors.primaryColor,
                      //                   size: 24,
                      //                 ),
                      //               ))
                      //         ]))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
