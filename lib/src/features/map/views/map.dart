import 'package:flutter/material.dart' hide FilledButton;
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/widget/draggable_dlv_sheet.dart';
import 'package:udrive/src/features/map/views/widget/draggable_sheet.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:udrive/src/features/map/views/widget/map_widgets.dart';
import 'package:udrive/src/global/controller/location_controller.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/plugin/custom_info_window.dart';
import 'package:udrive/src/src_barrel.dart';

class MapWidget extends StatefulWidget {
  final DeliveryMode deliveryMode;
  final bool isSearch;
  const MapWidget(
      {this.deliveryMode = DeliveryMode.none,
      this.isSearch = false,
      super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final locationController = Get.find<LocationController>();
  final rideController = Get.find<RideController>();
  final dlvController = Get.find<DeliveryController>();
  final Completer<GoogleMapController> _controller = Completer();
  final Loc loc = Loc(name: TextEditingController());

  static const double defZoom = 15;
  bool mapIsReady = false;
  final CustomInfoWindowController userIWC = CustomInfoWindowController();
  final CustomInfoWindowController destinationIWC =
      CustomInfoWindowController();
  final CustomInfoWindowController driverIWC = CustomInfoWindowController();

  Future<void> moveCamera(LatLng ll) async {
    final GoogleMapController controller = await _controller.future;
    final initPos = CameraPosition(target: ll, zoom: defZoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(initPos));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (widget.isSearch) {
      rideController.directions.value = Directions();
      dlvController.directions.value = Directions();
    }
    loc.llng = locationController.currentLocation.value;
    if (widget.deliveryMode == DeliveryMode.none) {
      rideController.currentRideStatus.listen((p0) {
        if (p0 == RideStates.rideStarted) {
          if (mounted) {
            userIWC.hideInfoWindow!();
          }
        }
      });
      rideController.currentTrip.listen((p0) {
        if (rideController.isIn([
          RideStates.foundDriver,
          RideStates.rideStarted,
          RideStates.driverArrived
        ])) {
          if (mounted) {
            destinationIWC.updateInfoWindow!(p0.driver!.locationData!.llng!);
          }
        }
      });
    } else {
      dlvController.currentDlvStatus.listen((p0) {
        if (p0 == DeliveryStates.dlvStarted) {
          if (mounted) {
            userIWC.hideInfoWindow!();
          }
        }
      });
      dlvController.currentDelivery.listen((p0) {
        if (dlvController.isIn([
          DeliveryStates.foundDriver,
          DeliveryStates.dlvStarted,
          DeliveryStates.driverArrived
        ])) {
          if (mounted) {
            destinationIWC.updateInfoWindow!(p0.driver!.locationData!.llng!);
          }
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        rideController.getNotif();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = Ui.width(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: locationController.currentLocation.value,
                zoom: defZoom),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            compassEnabled: false,
            markers: {
              if (widget.isSearch && loc.llng != null)
                Marker(
                    markerId: const MarkerId("current_loc"),
                    position: loc.llng!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue))
            },
            polylines: {
              if (currentDirection().bounds != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: AppColors.accentColor,
                  startCap: Cap.squareCap,
                  endCap: Cap.squareCap,
                  width: 4,
                  points: currentDirection()
                      .polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onTap: (llng) {
              setState(() {
                loc.llng = llng;
              });
            },
            onCameraMove: (_) {
              if (!mapIsReady) return;
              if (userIWC.onCameraMove != null) {
                userIWC.onCameraMove!();
              }
              if (driverIWC.onCameraMove != null) {
                driverIWC.onCameraMove!();
              }
              if (destinationIWC.onCameraMove != null) {
                destinationIWC.onCameraMove!();
              }
            },
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
              if (!widget.isSearch) {
                driverIWC.googleMapController = controller;
                driverIWC.addInfoWindow!(
                    DriversCar(),
                    widget.deliveryMode != DeliveryMode.none
                        ? dlvController.driversLocation.value
                        : rideController.driversLocation.value);
                userIWC.googleMapController = controller;
                userIWC.addInfoWindow!(
                    LocationWidget(), locationController.currentLocation.value);
                destinationIWC.googleMapController = controller;
                destinationIWC.addInfoWindow!(
                    LocationWidget(
                      isUser: false,
                    ),
                    widget.deliveryMode != DeliveryMode.none
                        ? dlvController.currentDelivery.value.dstLLNG
                        : rideController.currentTrip.value.dstLLNG);
              }

              changeMapMode();
              mapIsReady = true;
              setState(() {});
            },
          ),
          // if (widget.isSearch)
          //   Positioned(
          //       left: 24,
          //       right: 24,
          //       bottom: 56,
          //       child: FilledButton.white(() async {
          //         if (loc.llng != null) {
          //           print(loc.llng);
          //           final c = await HttpService.getMyLocation(loc.llng!);
          //           if (c == null) return;
          //           await MyPrefs.saveHomeLoc(c);
          //           Get.back<Loc>(result: c);
          //         }
          //       }, "Confirm")),
          if (widget.isSearch)
            Positioned(
                left: 24,
                right: 24,
                top: 56,
                child: CurvedContainer(
                  padding: EdgeInsets.all(24),
                  child: SizedText.thin(
                      "Please choose your home location by clicking on the place"),
                )),
          if (widget.isSearch)
            Positioned(
                left: 24,
                right: 24,
                bottom: 56,
                child: FilledButton.white(() async {
                  if (loc.llng != null) {
                    final c = await HttpService.getMyLocation(loc.llng!);
                    if (c == null) return;
                    await MyPrefs.saveHomeLoc(c);
                    Get.back<Loc>(result: c);
                  }
                }, "Confirm")),
          if (!widget.isSearch)
            CustomInfoWindow(
              controller: userIWC,
              height: 45,
              width: w / 2,
              offset: Offset((w / 2) + 22, -22),
            ),
          if (!widget.isSearch)
            CustomInfoWindow(
              controller: destinationIWC,
              height: 45,
              width: w / 2,
              offset: Offset((w / 2) + 22, -22),
            ),
          if (!widget.isSearch)
            CustomInfoWindow(
              controller: driverIWC,
              height: 64,
              width: 64,
            ),
          mapIsReady
              ? const SizedBox()
              : Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Color(0xff171e2e),
                ),
          if (!widget.isSearch)
            Positioned(
              left: 24,
              top: 36,
              child: SvgIconButton(
                Assets.back,
                () {
                  Get.off(HomeScreen());
                },
                size: 40,
                padding: 8,
              ),
            ),
          if (!widget.isSearch)
            Positioned(
              right: 24,
              top: 36,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.secondaryColor,
                child: SvgIconButton(
                  Assets.menu,
                  () {
                    widget.deliveryMode != DeliveryMode.none
                        ? dlvController.expand()
                        : rideController.expand();
                  },
                  size: 40,
                  padding: 12,
                ),
              ),
            ),
          if (!widget.isSearch)
            widget.deliveryMode != DeliveryMode.none
                ? DraggableDlvBottomSheet()
                : DraggableMapBottomSheet(),
        ],
      ),
    );
  }

  changeMapMode() async {
    final ms = await rootBundle.loadString("assets/json/style.json");
    final GoogleMapController cont = await _controller.future;
    cont.setMapStyle(ms);
  }

  Directions currentDirection() {
    if (widget.deliveryMode == DeliveryMode.none) {
      return rideController.directions.value;
    } else {
      return dlvController.directions.value;
    }
  }
}
