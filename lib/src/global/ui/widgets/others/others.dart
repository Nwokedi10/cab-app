import 'package:flutter/material.dart' hide FilledButton;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/global/services/mypref.dart';
import '../../../../features/home/controllers/settings_controller.dart';
import '/src/global/ui/ui_barrel.dart';
import '/src/src_barrel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class WidgetOrNull extends StatelessWidget {
  final Widget? child;
  final bool shouldShowOnlyIf;
  const WidgetOrNull(this.shouldShowOnlyIf, {this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return shouldShowOnlyIf ? child ?? const SizedBox() : const SizedBox();
  }
}

class NetOrAssetImage extends StatelessWidget {
  final String url;
  final double? height, width;
  const NetOrAssetImage(this.url, {this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return url.startsWith("http")
        ? Image.network(
            url,
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
        : Image.asset(
            url,
            height: height,
            fit: BoxFit.cover,
            width: width,
          );
  }
}

class UniversalImage extends StatelessWidget {
  final String url;
  final double? height, width;
  const UniversalImage(this.url, {this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return url.startsWith("/")
        ? Image.file(
            File(url),
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
        : NetOrAssetImage(
            url,
            height: height,
            width: width,
          );
  }
}

class CircularProgress extends StatefulWidget {
  const CircularProgress(this.size,
      {this.secondaryColor = AppColors.accentColor,
      this.primaryColor = AppColors.primaryColor,
      this.lapDuration = 1000,
      this.strokeWidth = 5.0,
      this.child,
      Key? key})
      : super(key: key);

// 2
  final double size;
  final Color secondaryColor;
  final Color primaryColor;
  final int lapDuration;
  final Widget? child;
  final double strokeWidth;

  @override
  State<CircularProgress> createState() => _CircularProgress();
}

class _CircularProgress extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
// 2
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.lapDuration))
      ..repeat();
  }

// 3
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// 4
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(controller),
      child: CustomPaint(
        painter: CirclePaint(
            secondaryColor: widget.secondaryColor,
            primaryColor: widget.primaryColor,
            strokeWidth: widget.strokeWidth),
        size: Size(widget.size, widget.size),
        child: widget.child,
      ),
    );
  }
}

// 1
class CirclePaint extends CustomPainter {
  final Color secondaryColor;
  final Color primaryColor;
  final double strokeWidth;

  // 2
  double _degreeToRad(double degree) => degree * pi / 180;

  CirclePaint(
      {this.secondaryColor = Colors.grey,
      this.primaryColor = Colors.blue,
      this.strokeWidth = 15});
  @override
  void paint(Canvas canvas, Size size) {
    double centerPoint = size.height / 2;

    Paint paint = Paint()
      ..color = primaryColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    paint.shader = SweepGradient(
      colors: [secondaryColor, primaryColor],
      tileMode: TileMode.repeated,
      startAngle: _degreeToRad(270),
      endAngle: _degreeToRad(270 + 360.0),
    ).createShader(
        Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: 0));
// 1
    var scapSize = strokeWidth * 0.70;
    double scapToDegree = scapSize / centerPoint;
// 2
    double startAngle = _degreeToRad(270) + scapToDegree;
    double sweepAngle = _degreeToRad(360) - (2 * scapToDegree);

    canvas.drawArc(const Offset(0.0, 0.0) & Size(size.width, size.width),
        startAngle, sweepAngle, false, paint..color = primaryColor);
  }

  @override
  bool shouldRepaint(CirclePaint oldDelegate) {
    return true;
  }
}

class ScaleAnimWidget extends StatefulWidget {
  final Widget? child;
  final double? start, end;
  final Duration d;
  final Alignment a;
  const ScaleAnimWidget(
      {this.child,
      this.start = 0.7,
      this.end = 1.0,
      this.d = const Duration(milliseconds: 350),
      this.a = Alignment.center,
      Key? key})
      : super(key: key);

  @override
  State<ScaleAnimWidget> createState() => _ScaleAnimWidgetState();
}

class _ScaleAnimWidgetState extends State<ScaleAnimWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: widget.d);
    _animation = Tween<double>(begin: widget.start, end: widget.end)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: _animation.value, alignment: widget.a, child: widget.child);
  }
}

class FadeAnimWidget extends StatefulWidget {
  final Widget? child;
  final bool fadeIn;
  final Duration d;
  const FadeAnimWidget(
      {this.child,
      this.fadeIn = true,
      this.d = const Duration(milliseconds: 500),
      Key? key})
      : super(key: key);

  @override
  State<FadeAnimWidget> createState() => _FadeAnimWidgetState();
}

class _FadeAnimWidgetState extends State<FadeAnimWidget> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: widget.fadeIn ? 0.2 : 1.0,
          end: widget.fadeIn ? 1.0 : 0.2,
        ),
        duration: widget.d,
        builder: (_, x, y) {
          return Opacity(opacity: x, child: widget.child);
        });
  }
}

class SplashAnimWidget extends StatefulWidget {
  final Widget? childA, childB;
  const SplashAnimWidget({this.childA, this.childB, Key? key})
      : super(key: key);

  @override
  State<SplashAnimWidget> createState() => _SplashAnimWidgetState();
}

class _SplashAnimWidgetState extends State<SplashAnimWidget> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 2.0,
          end: 1.0,
        ),
        duration: Duration(seconds: 3),
        curve: Curves.easeOut,
        builder: (_, x, y) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.logo,
                height: 100 * (x / 2),
                width: 100 * (x / 2),
              ),
              Ui.boxWidth(24),
              AppText.bold(
                "SafeSpace",
                fontSize: (2 - x) * 40,
                alignment: TextAlign.start,
                color: AppColors.white,
              ),
              // SizedBox(
              //     width: (2 - x) * 120,
              //     child: Transform.scale(
              //         scale: 2 - x,
              //         child: AppText.bold("SafeSpace", fontSize: (2-x)*24))),
            ],
          );
        });
  }
}

class GradientWidget extends StatelessWidget {
  const GradientWidget(
      {this.b = Alignment.topLeft,
      this.child,
      this.e = Alignment.bottomRight,
      this.colors = const [AppColors.primaryColor, AppColors.accentColor],
      Key? key})
      : super(key: key);
  final Widget? child;
  final Alignment b, e;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: b,
        end: e,
        colors: colors,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class SSLogoWidget extends StatelessWidget {
  final double size;
  final bool isGradient;
  final Color color;
  const SSLogoWidget(
      {this.size = 48,
      this.isGradient = false,
      this.color = Colors.white,
      super.key});

  Widget get myLogo => SvgPicture.asset(
        Assets.logo,
        color: Colors.white,
        height: size,
        width: size,
      );

  @override
  Widget build(BuildContext context) {
    return isGradient ? GradientWidget(child: myLogo) : myLogo;
  }
}

class PageIndicator extends StatefulWidget {
  final int dotCount;
  final double spacing, dotSize;
  final Color activeColor, inactiveColor;
  final Duration duration;
  final PageController controller;

  const PageIndicator(
    this.controller, {
    this.dotCount = 4,
    this.dotSize = 8,
    this.spacing = 8,
    this.duration = const Duration(seconds: 5),
    this.activeColor = AppColors.white,
    this.inactiveColor = Colors.grey,
    Key? key,
  }) : super(key: key);

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    widget.controller.addListener(() {
      changeIndex(widget.controller.page!.toInt());
    });
    if (widget.duration.inSeconds != 0) {
      timer = Timer.periodic(widget.duration, (timer) {
        nextPage();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.duration.inSeconds != 0) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.dotCount * ((2 * widget.spacing) + widget.dotSize),
      height: 10,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.dotCount,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing),
              child: CircleDot(
                size: widget.dotSize,
                color: index == currentIndex
                    ? widget.activeColor
                    : widget.inactiveColor,
              ));
        },
      ),
    );
  }

  changeIndex(int a) {
    currentIndex = a;
    if (mounted) {
      setState(() {});
    }
  }

  nextPage() {
    if (currentIndex == widget.dotCount - 1) {
      currentIndex = 0;
      widget.controller.animateToPage(0,
          duration: const Duration(seconds: 1), curve: Curves.easeIn);
    } else {
      currentIndex++;
      widget.controller
          .nextPage(duration: const Duration(seconds: 1), curve: Curves.easeIn);
    }
    if (mounted) {
      setState(() {});
    }
  }
}

class OutlinedContainer extends StatelessWidget {
  final Color color;
  final double radius, height;
  final double? width;
  final Widget? child;
  final bool isCircle;
  const OutlinedContainer(
      {this.color = AppColors.primaryColor,
      this.radius = 24,
      this.height = 48,
      this.width,
      this.isCircle = false,
      this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.maxFinite,
      decoration: BoxDecoration(
          border: Border.all(color: color),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(radius)),
      child: child,
    );
  }
}

class SocialButtonContainer extends StatelessWidget {
  const SocialButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.social(() async {
          final b = await MyPrefs.googleLogin();
          if (b) {
            Get.to(HomeScreen());
          }
        }, Assets.googleLogo),
        Ui.boxWidth(32),
        FilledButton.social(() async {
          final b = await MyPrefs.appleLogin();
          if (b) {
            Get.to(HomeScreen());
          }
        }, Assets.appleLogo),
      ],
    );
  }
}

class ConcCircle extends StatelessWidget {
  const ConcCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accentColor.withOpacity(0.5),
      ),
      child: const CircleAvatar(
        backgroundColor: AppColors.accentColor,
        radius: 3,
      ),
    );
  }
}

class PaymentCardIcon extends StatelessWidget {
  const PaymentCardIcon(this.cardType, {super.key});
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    return cardType != CardType.invalid
        ? Image.asset(
            cardType.icon,
            height: 56.0,
          )
        : const Icon(
            IconlyLight.danger,
            size: 24,
            color: AppColors.red,
          );
  }
}

class RefreshScrollView extends StatefulWidget {
  final Future<void> Function() onRefreshed, onExtend;
  final ScrollController? scrollController;
  final Widget child;
  const RefreshScrollView(
      {required this.onRefreshed,
      required this.onExtend,
      required this.child,
      this.scrollController,
      super.key});

  @override
  State<RefreshScrollView> createState() => _RefreshScrollViewState();
}

class _RefreshScrollViewState extends State<RefreshScrollView> {
  ScrollController scont = ScrollController();
  bool loading = false;

  @override
  void initState() {
    if (widget.scrollController != null) {
      scont = widget.scrollController!;
    }
    scont.addListener(() async {
      var nextPageTrigger = scont.position.maxScrollExtent + 48;
      if (scont.position.pixels > nextPageTrigger) {
        if (mounted) {
          setState(() {
            loading = true;
          });
          await widget.onExtend();
          setState(() {
            loading = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.onRefreshed();
      },
      color: AppColors.accentColor,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: scont,
          child: Column(
            children: [
              widget.child,
              if (loading) LoadingIndicator(padding: 24)
            ],
          )),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double size, padding;

  const LoadingIndicator({this.size = 24, this.padding = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          height: size,
          width: size,
          child: const CircularProgressIndicator(
            color: AppColors.accentColor,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget badgeBox(Widget child,
    {VoidCallback? onTap,
    Alignment a = Alignment.bottomRight,
    bool shdShow = true}) {
  return Stack(
    children: [
      child,
      shdShow
          ? Positioned.fill(
              child: Ui.align(
                  align: a,
                  child: GestureDetector(onTap: onTap, child: badge())))
          : SizedBox(),
    ],
  );
}

Widget badge(
    {Color color = AppColors.secondaryColor,
    double size = 50,
    IconData? icon}) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: Center(
        child: Icon(
      icon ?? IconlyLight.plus,
      color: AppColors.white,
    )),
  );
}

class ChooseCam extends StatefulWidget {
  const ChooseCam({Key? key}) : super(key: key);

  @override
  State<ChooseCam> createState() => _ChooseCamState();
}

class _ChooseCamState extends State<ChooseCam> {
  final ImagePicker _picker = ImagePicker();
  final controller = Get.find<SettingsController>();

  XFile? finalImage;
  List<IconData> icons = [IconlyLight.camera, IconlyLight.image];
  List<String> iconText = ["Camera", "Gallery"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 24.0, right: 24, left: 24),
              child: AppText.medium("Choose Photo")),
          Row(
              children: List.generate(
                  2,
                  (index) => GestureDetector(
                      onTap: () async {
                        await buildCamPicker(index);
                      },
                      child: buildVIT(index)))),
          Ui.boxHeight(56)
        ],
      ),
    );
  }

  buildCamPicker(int index) async {
    if (index == 0) {
      finalImage = await _picker.pickImage(source: ImageSource.camera);
    } else {
      finalImage = await _picker.pickImage(source: ImageSource.gallery);
    }

    CroppedFile? file = await ImageCropper().cropImage(
      sourcePath: finalImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      // compressQuality: 100,
      maxHeight: 256,
      maxWidth: 256,
      compressFormat: ImageCompressFormat.jpg,
      cropStyle: CropStyle.circle,
      uiSettings: [
        IOSUiSettings(
          title: "Adjust Size",
        ),
        AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "Adjust Size",
        ),
      ],
    );

    // int a = File(file!.path).lengthSync();

    // int kb = a ~/ 1024;
    String filepath = file!.path;

    // if (kb >= 5000) {
    //   ImageProperties properties =
    //       await FlutterNativeImage.getImageProperties(filepath);
    //   File compressedFile = await FlutterNativeImage.compressImage(filepath,
    //       quality: 80, targetWidth: 144, targetHeight: 144);
    //   filepath = compressedFile.path;
    // }

    controller.changeUserImage(filepath);
    Get.back();
  }

  Widget buildVIT(int i) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icons[i],
            size: 48,
            color: AppColors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          AppText.thin(
            iconText[i],
          )
        ],
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(
        color: AppColors.secondaryColor,
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  final int durationInMinutes;
  final Function onTimerFinished;

  const TimerText(
      {super.key,
      required this.durationInMinutes,
      required this.onTimerFinished});

  @override
  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  late Timer _timer;
  int _durationInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _durationInSeconds = widget.durationInMinutes * 60;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_durationInSeconds > 0) {
          _durationInSeconds--;
        } else {
          _timer.cancel();
          widget.onTimerFinished();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _durationInSeconds ~/ 60;
    int seconds = _durationInSeconds % 60;

    return AppText.thin(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});
  final cd = 0.75;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Shimmer.fromColors(
        baseColor: AppColors.grey.withOpacity(0.3),
        highlightColor: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
                Ui.boxWidth(8),
                Container(
                  width: Ui.width(context) * cd,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            Ui.boxHeight(32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
                Ui.boxWidth(8),
                Container(
                  width: Ui.width(context) * cd,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
