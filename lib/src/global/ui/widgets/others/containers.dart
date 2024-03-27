import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';

import '../../../../src_barrel.dart';

class CurvedContainer extends StatelessWidget {
  final Widget? child;
  final double radius;
  final double? width;
  final String? image;
  final Color color;
  final Border? border;
  final bool shouldClip;
  final VoidCallback? onPressed;
  final EdgeInsets? margin, padding;
  const CurvedContainer(
      {this.child,
      this.radius = 5,
      this.width,
      this.onPressed,
      this.margin,
      this.padding,
      this.border,
      this.image,
      this.shouldClip = true,
      this.color = AppColors.primaryColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        margin: margin,
        clipBehavior: shouldClip ? Clip.hardEdge : Clip.none,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: Ui.circularRadius(radius),
            color: color,
            border: border,
            image: image == null
                ? null
                : DecorationImage(image: AssetImage(image!), fit: BoxFit.fill)),
        child: child,
      ),
    );
  }
}

class SinglePageScaffold extends StatelessWidget {
  final String? title;
  final Widget? child;
  final bool safeArea;
  const SinglePageScaffold(
      {this.title, this.child, this.safeArea = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: title),
      body: safeArea ? SafeArea(child: child!) : child,
    );
  }
}

class SizedText extends StatelessWidget {
  final Widget? child;
  final double space;
  const SizedText({this.child, this.space = 48, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Ui.width(context) - space,
      child: child,
    );
  }

  static thin(String text, {double space = 48}) {
    return SizedText(
      child: AppText.thin(text),
      space: space,
    );
  }
}

class SvgIconButton extends StatelessWidget {
  final double size;
  final Color color;
  final String url;
  final VoidCallback onTap;
  final double padding;
  const SvgIconButton(this.url, this.onTap,
      {this.size = 24,
      this.color = AppColors.white,
      this.padding = 8,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: (size + 16) / 2,
      customBorder: CircleBorder(),
      child: SizedBox(
        height: size + 8,
        width: size + 8,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SvgPicture.asset(
            url,
            height: size,
            width: size,
            color: color,
          ),
        ),
      ),
    );
  }
}
