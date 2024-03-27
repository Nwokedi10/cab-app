import 'package:flutter/material.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import '/src/app/app_barrel.dart';
import '/src/utils/utils_barrel.dart';

///This is the general widget for text in this app
///use this rather than the flutter provided text widget
///
/// static methods are provided for fontWeights
/// eg. AppText.semiBoldItalic(
///       "my text",
///       fontSize: 20,
///      )...
///   for -> fontWeight = 600
///          fontSize = 20
///          fontStyle = italic
///
/// if there are font weight that are not provided here
/// feel free to add a  method for it.
/// happy coding :)
///
class AppText extends StatelessWidget {
  final String text;
  final FontWeight? weight;
  final double? fontSize;
  final FontStyle? style;
  final String? fontFamily;
  final Color? color;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextOverflow overflow;
  final int? maxlines;

  ///fontSize = 14
  const AppText(
    this.text, {
    Key? key,
    this.weight = FontWeight.w500,
    this.fontSize,
    this.style = FontStyle.normal,
    this.color,
    this.fontFamily,
    this.alignment = TextAlign.start,
    this.overflow = TextOverflow.visible,
    this.maxlines,
    this.decoration,
  }) : super(key: key);

  ///fontSize: 15
  ///weight: w700
  static AppText bold(
    String text, {
    Color? color,
    TextAlign? alignment,
    double? fontSize = 17,
  }) =>
      AppText(
        text,
        weight: FontWeight.w700,
        color: color,
        alignment: alignment,
        fontSize: fontSize,
      );

  ///fontSize: 15
  ///weight: w300
  static AppText thin(
    String text, {
    Color? color,
    TextAlign? alignment,
    TextOverflow overflow = TextOverflow.visible,
    double? fontSize = 17,
  }) =>
      AppText(
        text,
        weight: FontWeight.w300,
        color: color,
        alignment: alignment,
        fontSize: fontSize,
        overflow: overflow,
      );

  ///weight: w500
  static AppText medium(
    String text, {
    Color? color,
    String? fontFamily,
    double fontSize = 17,
    TextAlign? alignment,
    TextOverflow overflow = TextOverflow.visible,
  }) =>
      AppText(
        text,
        fontSize: fontSize,
        weight: FontWeight.w500,
        overflow: overflow,
        alignment: alignment,
        fontFamily: fontFamily,
        color: color,
      );

  ///weight: w300
  ///fontSize: 17
  ///color: #FFFFFF
  static AppText button(
    String text, {
    Color color = AppColors.white,
    double fontSize = 17,
    TextAlign? alignment,
    TextDecoration? decoration,
  }) =>
      AppText(
        text,
        fontSize: fontSize,
        weight: FontWeight.w300,
        decoration: decoration,
        alignment: alignment,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      // softWrap: false,
      style: TextStyle(
        decoration: decoration,
        fontSize: fontSize ?? 14,
        color: color ?? AppColors.white,
        fontWeight: weight,
        overflow: overflow,
        fontStyle: style,
        fontFamily: fontFamily,
      ),
      textAlign: alignment,
    );
  }
}

class AppRichText extends StatelessWidget {
  final String text;
  final List<IconData?> icons;
  final Color? color;

  const AppRichText(this.text,
      {this.icons = const [], this.color = AppColors.white, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icons[0] != null)
          Icon(
            icons[0],
            color: AppColors.accentColor,
          ),
        Ui.boxWidth(8),
        AppText.thin(text, color: color),
        Ui.boxWidth(8),
        if (icons.length > 1)
          Icon(
            icons[1],
            color: AppColors.accentColor,
          ),
      ],
    );
  }
}
