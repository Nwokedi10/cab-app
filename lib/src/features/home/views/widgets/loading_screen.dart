import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class LoadingScreen extends StatefulWidget {
  final String message;
  final Widget nextScreen;
  final Function onLoad;
  final Function? onBack;
  const LoadingScreen(this.message, this.onLoad, this.nextScreen,
      {this.onBack, super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = true;

  @override
  void initState() {
    runCode();
    super.initState();
  }

  runCode() async {
    var c = await widget.onLoad();
    c ??= true;
    if (c) {
      Get.to(widget.nextScreen);
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onBack != null) {
          await widget.onBack!();
        }

        return true;
      },
      child: Scaffold(
        appBar: backAppBar(),
        body: SizedBox(
          width: Ui.width(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? CircularProgress(
                      100,
                      strokeWidth: 16,
                      primaryColor: AppColors.accentColor,
                      secondaryColor: AppColors.accentColor.withOpacity(0),
                    )
                  : Icon(IconlyLight.danger, color: AppColors.white, size: 100),
              Ui.boxHeight(48),
              isLoading
                  ? AppText.thin(widget.message)
                  : InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });

                        await runCode();
                      },
                      child: SizedBox(
                        width: 128,
                        height: 56,
                        child: Center(child: AppText.medium("Retry")),
                      ),
                    ),
              Ui.boxHeight(24),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FilledButton.outline(() async {
                    if (widget.onBack != null) {
                      await widget.onBack!();
                    }
                    Ui.showSnackBar("Operation Cancelled");
                    setState(() {
                      isLoading = false;
                    });
                    Get.back();
                  }, "Cancel"))
            ],
          ),
        ),
      ),
    );
  }
}
