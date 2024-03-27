import 'package:flutter/material.dart';

import '../../../../global/ui/ui_barrel.dart';

class DefOrderPage extends StatelessWidget {
  final AppBar? appBar;
  final Widget? trip, image, desc, button;
  const DefOrderPage(
      {this.appBar, this.button, this.desc, this.image, this.trip, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
          child: Column(
        children: [
          // if (trip != null )
          Ui.padding(
            child: trip,
          ),
          if (image != null) Expanded(child: image!),
          Ui.padding(child: desc),
          image != null ? Ui.boxHeight(24) : const Spacer(),
          Ui.padding(child: button),
        ],
      )),
    );
  }
}
