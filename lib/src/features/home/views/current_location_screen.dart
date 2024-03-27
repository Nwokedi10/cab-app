import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/views/delivery/delivery_summary_screen.dart';
import 'package:udrive/src/features/home/views/order_ride_screen.dart';
import 'package:udrive/src/features/home/views/widgets/custom_dropdown.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/payment_dropdown.dart';
import 'package:udrive/src/features/home/views/widgets/searchfields.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/global/controller/location_controller.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class CurrentLocationScreen extends StatefulWidget {
  final DeliveryMode deliveryMode;
  const CurrentLocationScreen(
      {this.deliveryMode = DeliveryMode.none, super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  final controller = Get.find<HomeController>();
  final locController = Get.find<LocationController>();
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: widget.deliveryMode.clname,
      safeArea: true,
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              if (widget.deliveryMode != DeliveryMode.none)
                Ui.padding(
                  child: Column(
                    children: [
                      Ui.boxHeight(14),
                      SizedText(
                        child: AppText.thin(widget.deliveryMode.desc),
                      ),
                      Ui.boxHeight(24)
                    ],
                  ),
                ),
              // SearchFields(
              //     controller.textControllers[0], controller.textControllers[1]),
              Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: widget.deliveryMode == DeliveryMode.none ? 24.0 : 16.0,
                ),
                child: SearchFields(
                  controller.srcDst[0],
                  controller.srcDst[1],
                  stopLocs: widget.deliveryMode == DeliveryMode.none
                      ? controller.stopLocations
                      : null,
                  deliveryMode: widget.deliveryMode,
                ),
              ),

              Ui.boxHeight(24),
              ListTile(
                leading: const Icon(
                  IconlyLight.home,
                  color: AppColors.white,
                ),
                tileColor: AppColors.secondaryColor,
                onTap: () async {
                  if (MyPrefs.getHomeLoc().name?.value.text.isEmpty ?? true) {
                    final c = await Get.to<Loc>(const MapWidget(
                      isSearch: true,
                    ));
                    if (c != null) {
                      setState(() {
                        controller.srcDst[0] = MyPrefs.getHomeLoc();
                      });
                    }
                  } else {
                    setState(() {
                      controller.srcDst[0] = MyPrefs.getHomeLoc();
                    });
                  }
                },
                title: AppText.thin("Use Home Location", fontSize: 15),
                trailing: Icon(
                  IconlyLight.arrow_right_2,
                  color: AppColors.white,
                ),
              ),
              ListTile(
                leading: Icon(
                  IconlyLight.location,
                  color: AppColors.white,
                ),
                tileColor: AppColors.secondaryColor,
                onTap: () async {
                  Get.showOverlay(
                      asyncFunction: () async {
                        final c = await HttpService.getMyLocation(
                            locController.currentLocation.value);
                        if (c != null) {
                          setState(() {
                            controller.srcDst[0] = c;
                          });
                        }
                      },
                      opacity: 0.8,
                      loadingWidget: Center(child: CircularProgress(56)));
                },
                title: AppText.thin("Find My Location", fontSize: 15),
                trailing: Icon(
                  IconlyLight.arrow_right_2,
                  color: AppColors.white,
                ),
              ),
              Ui.padding(
                child: HeaderTile(
                  "Payment Method",
                  padding: 24,
                  child: PaymentDropDown(
                    dm: widget.deliveryMode,
                  ),
                ),
              ),
              if (widget.deliveryMode != DeliveryMode.none)
                Ui.padding(
                  child: HeaderTile(
                    "Package Size",
                    padding: 0,
                    child: CustomDropDown(
                      options: [
                        "Small Package Size(Bike)",
                        "Large Package Size(Car)"
                      ],
                      curOption: "Small Package Size(Bike)",
                    ),
                  ),
                ),
              if (widget.deliveryMode == DeliveryMode.none)
                Ui.padding(
                  child: HeaderTile(
                    "Vehicle Type",
                    padding: 0,
                    child: CustomDropDown(
                      options: HomeController.vehicleTypes,
                      curOption: controller.currentVehicleType.value.name,
                      onChanged: (val) {
                        controller.currentVehicleType.value = VehicleTypes
                            .values[HomeController.vehicleTypes.indexOf(val!)];
                      },
                    ),
                  ),
                ),

              // if (widget.deliveryMode == DeliveryMode.none)
              //   HeaderTile("Camera & Mic",
              //       child: SizedBox(
              //         width: Ui.width(context) - 48,
              //         child: AppText.thin(
              //             "Your driver’s camera and microphone will be switched on for your own security. Would you like to change these settings. ",
              //             color: AppColors.white.withOpacity(0.7)),
              //       ))
            ],
          )),
    );
  }
}
