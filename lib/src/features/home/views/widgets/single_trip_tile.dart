import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class SingleTripTile extends StatelessWidget {
  final String srcLocation, dstLocation;
  final String? srcValue, dstValue;
  final double srcValueOpacity, dstValueOpacity;
  final bool hasIcon;
  final VoidCallback? onTap;
  const SingleTripTile(
      {this.dstLocation = "Ozumba Mbadiwe",
      this.srcLocation = "Mary Slessor",
      this.srcValueOpacity = 1.0,
      this.dstValueOpacity = 1.0,
      this.srcValue,
      this.dstValue,
      this.onTap,
      this.hasIcon = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: AbsorbPointer(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              const Icon(
                IconlyLight.location,
                size: 12,
                color: AppColors.accentColor,
              ),
              Ui.boxWidth(8),
              SizedBox(
                  width: Ui.width(context) * 0.6,
                  child: AppText.thin(srcLocation,
                      overflow: TextOverflow.ellipsis)),
              const Spacer(),
              if (srcValue != null)
                AppText.thin(srcValue!,
                    color: AppColors.white.withOpacity(srcValueOpacity)),
            ],
          ),
          Ui.boxHeight(4),
          Row(
            children: [
              SizedBox(
                width: 12,
                child: Ui.align(
                  align: Alignment.center,
                  child: SvgPicture.asset(
                    Assets.arrowDown,
                    height: 17,
                  ),
                ),
              ),
              const Spacer(),
              if (hasIcon)
                Icon(
                  IconlyLight.arrow_right_2,
                  color: AppColors.accentColor,
                )
            ],
          ),
          Ui.boxHeight(4),
          Row(
            children: [
              ConcCircle(),
              Ui.boxWidth(8),
              SizedBox(
                  width: Ui.width(context) * 0.6,
                  child: AppText.thin(dstLocation,
                      overflow: TextOverflow.ellipsis)),
              const Spacer(),
              if (dstValue != null)
                AppText.thin(dstValue!,
                    color: AppColors.white.withOpacity(dstValueOpacity)),
            ],
          )
        ]),
      ),
    );
  }
}

class LineTripTile extends StatelessWidget {
  final Trip trip;
  final bool hasIcon;
  const LineTripTile({required this.trip, this.hasIcon = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasIcon)
          Icon(
            IconlyLight.location,
            size: 16,
          ),
        Ui.boxWidth(4),
        AppText.thin(trip.src.maxLength(16),
            color: AppColors.white.withOpacity(0.3)),
        Ui.boxWidth(4),
        SvgPicture.asset(
          Assets.arrowLeft,
          color: AppColors.white.withOpacity(0.3),
        ),
        Ui.boxWidth(4),
        if (hasIcon) CircleDot(),
        Ui.boxWidth(4),
        AppText.thin(trip.dst.maxLength(16),
            color: AppColors.white.withOpacity(0.3)),
      ],
    );
  }
}
