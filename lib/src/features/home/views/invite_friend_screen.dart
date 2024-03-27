import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/ui/ui_barrel.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Invite Friends",
      child: Column(
        children: [
          Ui.padding(
            child: SizedText.thin(
                "Share your referral link with friends a get a discount on your next ride."),
          ),
          Image.asset(
            Assets.invite,
            width: Ui.width(context),
          ),
          Ui.padding(
            padding: 44,
            child: CurvedContainer(
              color: AppColors.accentColor,
              child: Row(children: [
                Expanded(
                    child:
                        AppText.thin("STONE23", alignment: TextAlign.center)),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: CurvedContainer(
                      onPressed: () async {
                        await Share.share("STONE23");
                      },
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: AppRichText(
                            "Share",
                            icons: [null, Icons.share_outlined],
                          ))),
                ))
              ]),
            ),
          )
        ],
      ),
    );
  }
}
