import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final bool disabled;
  final double width;
  final double height;
  final Color color;
  final bool center;
  final double? elevation;
  final double borderRadius;

  const AppOutlinedButton({
    required this.onPressed,
    required this.child,
    this.elevation,
    this.color = AppColors.white,
    this.width = 320,
    this.height = 56,
    this.borderRadius = 7,
    this.disabled = false,
    this.center = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: disabled ? AppColors.white : color,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: Ui.circularRadius(borderRadius),
        side: const BorderSide(
          color: AppColors.primaryColor,
          width: 2,
        ),
      ),
      onPressed: disabled ? null : onPressed,
      child: Container(
        padding: child == null
            ? EdgeInsets.symmetric(
                horizontal: (width - 40) / 2,
                vertical: (height - 40) / 2,
              )
            : null,
        height: height,
        width: width,
        child: center
            ? Center(
                child: child ??
                    (disabled
                        ? Container()
                        : const CircularProgressIndicator()),
              )
            : child ??
                (disabled ? Container() : const CircularProgressIndicator()),
      ),
    );
  }
}

class TextBtn extends StatelessWidget {
  const TextBtn(this.text,
      {this.color = AppColors.primaryColor,
      this.size = 24,
      this.onPressed,
      super.key});
  final String text;
  final Color color;
  final double size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
        child: AppText(
          text,
          fontSize: size,
          color: color,
        ),
      ),
    );
  }
}
