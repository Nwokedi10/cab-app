import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/ride_info_screen.dart';
import 'package:udrive/src/features/home/views/widgets/empty_screen.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';

import '../../../global/ui/ui_barrel.dart';
import '../../../global/ui/widgets/others/containers.dart';
import '../../../src_barrel.dart';
import '../controllers/home_controller.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  final controller = Get.find<HomeController>();

  bool isLoading = true;

  @override
  void initState() {
    // isLoading = controller.userTrips.isEmpty;
    getRides();
    super.initState();
  }

  Future getRides() async {
    if (mounted) {
      setState(() {
        isLoading = controller.userTrips.isEmpty;
      });
    }
    await controller.getTripHistory();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // -- get data  regno , NavigatorUserMediaError course  dept fac

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Ride History",
      child: Ui.padding(
          child: SafeArea(
        child: isLoading
            ? ListView.builder(
                itemCount: 8,
                itemBuilder: (_, i) {
                  return ShimmerWidget();
                })
            : Obx(() {
                return controller.userTrips.isEmpty
                    ? EmptyScreen()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.getTripHistory();
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (ctx, i) {
                            final m = controller.getMsg(i);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: AppText.medium(controller.msgKeys[i],
                                      fontSize: 22,
                                      color: AppColors.white.withOpacity(0.6)),
                                ),
                                ...List.generate(
                                    m.length,
                                    (index) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SingleTripTile(
                                              srcValueOpacity: 0.4,
                                              dstValueOpacity: 0.8,
                                              srcLocation: m[index].src,
                                              dstLocation: m[index].dst,
                                              srcValue: m[index].dstDate,
                                              dstValue: m[index].dstTime,
                                              onTap: () {
                                                Get.to(
                                                    RideInfoScreen(m[index]));
                                              },
                                            ),
                                            const AppDivider()
                                          ],
                                        ))
                              ],
                            );
                          },
                          itemCount: controller.msgs.length,
                        ),
                      );
              }),
      )),
    );
  }
}
