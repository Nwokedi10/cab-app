import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/features/map/views/widget/driver_tile.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';

import '../../../global/ui/widgets/others/containers.dart';
import '../../../src_barrel.dart';

class RideInfoScreen extends StatelessWidget {
  final Trip trip;
  const RideInfoScreen(this.trip, {super.key});

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Ride Info",
      safeArea: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Ui.padding(
          child: Column(
            children: [
              DriverTile(driver: trip.driver!),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: Ui.width(context),
                    height: 150,
                  ),
                  Positioned(
                    top: -60,
                    right: 12,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.secondaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.thin("Duration",
                              color: AppColors.accentColor, fontSize: 12),
                          Ui.boxWidth(4),
                          AppText.thin("${trip.duration!.inMinutes} mins",
                              fontSize: 24),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -12,
                    child: Image.asset(
                      Assets.carDef,
                      width: Ui.width(context) - 48,
                    ),
                  )
                ],
              ),
              AppText.thin(trip.driver!.car.name, color: AppColors.white40),
              Ui.boxHeight(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.thin("Plate No: ", color: AppColors.white40),
                  AppText.bold(trip.driver!.car.plateNo),
                ],
              ),
              AppDivider(),
              AppText.thin(trip.dstLongDate, color: AppColors.white40),
              Ui.boxHeight(16),
              SingleTripTile(
                srcLocation: trip.src,
                dstLocation: trip.dst,
                srcValue: trip.srcTime,
                dstValue: trip.dstTime,
              ),
              AppDivider(),
              Ui.boxHeight(8),
              AppText.thin("Payment", color: AppColors.white40),
              Ui.boxHeight(16),
              AppText.medium(trip.cost.toInt().toCurrency(),
                  fontFamily: 'Roboto', fontSize: 48),
              Ui.boxHeight(16),
              Row(
                children: [
                  AppText.thin("Payment Method", color: AppColors.white40),
                  const Spacer(),
                  AppText.thin(
                      MyPrefs.readData(MyPrefs.mpUdrivePaym) ?? "Cash"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
