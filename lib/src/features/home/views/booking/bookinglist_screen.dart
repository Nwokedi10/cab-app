import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/app/theme/colors.dart';
import 'package:udrive/src/features/home/controllers/booking_controller.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/views/booking/def_pages.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../../global/ui/ui_barrel.dart';

class BookingListScreen extends StatelessWidget {
  BookingListScreen({super.key});
  final controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Booking Lists",
      safeArea: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Ui.align(
              child: AppText.bold("Active Booking",
                  fontSize: 22, color: AppColors.white.withOpacity(0.6)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.all(24),
              itemBuilder: (ctx, i) {
                final m = controller.getBooking(i);
                return Column(
                  children: [
                    Ui.boxHeight(12),
                    Ui.align(
                      child: AppText.thin(controller.bookingKeys[i].name,
                          fontSize: 20, color: AppColors.grey),
                    ),
                    Ui.boxHeight(6),
                    ...List.generate(
                        m.length,
                        (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(DefBookingActionScreen(
                                        m[index],
                                        position: 2,
                                      ));
                                    },
                                    child: AbsorbPointer(
                                      child: SingleTripTile(
                                        srcValue: m[index].trip!.dstDate,
                                        dstValue: m[index].trip!.dstTime,
                                        srcValueOpacity: 0.4,
                                        dstValueOpacity: 0.8,
                                        srcLocation: m[index].trip!.src,
                                        dstLocation: m[index].trip!.dst,
                                      ),
                                    ),
                                  ),
                                  Ui.boxHeight(16),
                                  Divider(
                                    color: AppColors.secondaryColor,
                                  ),
                                ],
                              ),
                            ))
                  ],
                );
              },
              itemCount: controller.bookings.length,
            ),
          ),
        ],
      ),
    );
  }
}
