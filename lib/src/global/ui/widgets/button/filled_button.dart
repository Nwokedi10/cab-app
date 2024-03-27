import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

class FilledButton extends StatefulWidget {
  final Function? onPressed;
  final Widget? child;
  final String? text, icon;
  final bool? disabled;
  final Color color, borderColor;
  final bool isCircle, isWide, hasBorder;

  FilledButton({
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.disabled,
    this.isWide = true,
    this.isCircle = false,
    this.borderColor = AppColors.white,
    this.hasBorder = false,
    this.color = AppColors.accentColor,
    Key? key,
  }) : super(key: key);

  @override
  State<FilledButton> createState() => _FilledButtonState();

  static social(
    Function? onPressed,
    String icon,
  ) {
    return FilledButton(
      onPressed: onPressed,
      icon: icon,
      color: AppColors.white,
      isCircle: true,
    );
  }

  static half(
    Function? onPressed,
    String title,
  ) {
    return FilledButton(
      onPressed: onPressed,
      text: title,
      isWide: false,
    );
  }

  static white(
    Function? onPressed,
    String title,
  ) {
    return FilledButton(
      onPressed: onPressed,
      color: AppColors.white,
      text: title,
    );
  }

  static outline(Function? onPressed, String title,
      {Color color = AppColors.primaryColor}) {
    return FilledButton(
      onPressed: onPressed,
      hasBorder: true,
      text: title,
      color: color,
    );
  }
}

class _FilledButtonState extends State<FilledButton> {
  bool disabled = false;

  @override
  void initState() {
    disabled = widget.disabled ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: disabled ? AppColors.grey : widget.color,
      elevation: 2,
      shape: widget.isCircle
          ? const CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: Ui.circularRadius(8),
              side: widget.hasBorder
                  ? BorderSide(color: widget.borderColor)
                  : BorderSide.none,
            ),
      onPressed: disabled
          ? null
          : () async {
              setState(() {
                disabled = true;
              });
              await widget.onPressed!();
              setState(() {
                disabled = false;
              });
            },
      child: widget.isCircle
          ? Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: disabled
                      ? const LoadingIndicator()
                      : Image.asset(widget.icon!)),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              width: widget.isWide
                  ? double.maxFinite
                  : (Ui.width(context) / 2) - 36,
              child: Center(
                child: !disabled
                    ? widget.child ??
                        AppText.button(
                          widget.text!,
                          color: widget.hasBorder
                              ? widget.borderColor
                              : widget.color == AppColors.white
                                  ? AppColors.primaryColor
                                  : AppColors.white,
                        )
                    : const LoadingIndicator(),
              )),
    );
  }
}
