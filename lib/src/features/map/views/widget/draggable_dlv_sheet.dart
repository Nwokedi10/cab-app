import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/map/views/widget/draggable_sheet.dart';
import 'package:udrive/src/features/map/views/widget/driver_tile.dart';
import 'package:udrive/src/features/map/views/widget/ride_progress.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class DraggableDlvBottomSheet extends StatefulWidget {
  const DraggableDlvBottomSheet({super.key});

  @override
  State<DraggableDlvBottomSheet> createState() =>
      _DraggableDlvBottomSheetState();
}

class _DraggableDlvBottomSheetState extends State<DraggableDlvBottomSheet> {
  final controller = Get.find<DeliveryController>();
  final homeController = Get.find<HomeController>();
  List<Widget> screens = [];

  @override
  void initState() {
    screens = [
      collapsedScreen(), //0.12
      containerRideProgress(), //0.24
      fullScreen() //1
    ];
    controller.changeScreen(controller.currentDlvStatus.value.screen);

    controller.dragController.addListener(() {
      final curSize = controller.dragController.size;
      if (!mounted) return;
      if (curSize > 0.3 &&
          controller.isGreaterThan(DeliveryStates.dlvStarted)) {
        controller.changeScreen(2);
      } else if (curSize > 0.2 &&
          controller.isGreaterThan(DeliveryStates.dlvStarted)) {
        controller.changeScreen(1);
      } else {
        controller.changeScreen(0);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return DraggableScrollableSheet(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              clipBehavior: Clip.none,
              child: Obx(() {
                return controller.curScreen.value == 2
                    ? ColoredBox(
                        color: AppColors.primaryColor,
                        child: SizedBox(
                            height: Ui.height(context),
                            child: screens[controller.curScreen.value]),
                      )
                    : DragContainer(
                        child: SizedBox(
                            height: Ui.height(context),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  screens[controller.curScreen.value],
                                ])),
                      );
              }),
            );
          },
          controller: controller.dragController,
          minChildSize: 0.12,
          initialChildSize: controller.currentDlvStatus.value.size,
          maxChildSize:
              controller.isGreaterThan(DeliveryStates.dlvStarted) ? 1 : 0.24,
          snap: true,
          snapSizes: controller.isGreaterThan(DeliveryStates.dlvStarted)
              ? const [0.24]
              : null,
        );
      },
    );
  }

  Widget containerRideProgress() {
    return SizedBox(
      height: Ui.height(context) * 0.24,
      child: Center(
          child: RideProgressWidget(
        deliveryMode: controller.currentDeliveryMode.value,
      )),
    );
  }

  Widget fullScreen() {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        children: [
          Ui.align(
              align: Alignment.centerRight,
              child: SvgIconButton(Assets.close, () {
                controller.reduce();
              })),
          Ui.boxHeight(48),
          RideProgressWidget(
            deliveryMode: controller.currentDeliveryMode.value,
          ),
          Ui.boxHeight(64),
          DriverTile(driver: controller.currentDelivery.value.driver!)
        ],
      ),
    );
  }

  Widget collapsedScreen() {
    return Ui.align(
        align: Alignment.center,
        child: SvgIconButton(
          Assets.expand,
          () {},
          size: 56,
        ));
  }
}
