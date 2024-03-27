import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowController {
  /// Add custom [Widget] and [Marker]'s [LatLng] to [CustomInfoWindow] and make it visible.
  Function(Widget, LatLng)? addInfoWindow;

  /// Notifies [CustomInfoWindow] to redraw as per change in position.
  VoidCallback? onCameraMove;

  /// Hides [CustomInfoWindow].
  VoidCallback? hideInfoWindow;

  /// Updates [CustomInfoWindow] based on new LatLng.
  Function(LatLng)? updateInfoWindow;

  /// Holds [GoogleMapController] for calculating [CustomInfoWindow] position.
  GoogleMapController? googleMapController;

  void dispose() {
    addInfoWindow = null;
    onCameraMove = null;
    hideInfoWindow = null;
    updateInfoWindow = null;
    googleMapController = null;
  }
}

/// A stateful widget responsible to create widget based custom info window.
class CustomInfoWindow extends StatefulWidget {
  /// A [CustomInfoWindowController] to manipulate [CustomInfoWindow] state.
  final CustomInfoWindowController controller;

  /// Offset to maintain space between [Marker] and [CustomInfoWindow].
  final Offset offset;

  /// Height of [CustomInfoWindow].
  final double height;

  /// Width of [CustomInfoWindow].
  final double width;

  const CustomInfoWindow({
    super.key,
    required this.controller,
    this.offset = const Offset(0, 0),
    this.height = 50,
    this.width = 100,
  })  : assert(height >= 0),
        assert(width >= 0);

  @override
  _CustomInfoWindowState createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {
  bool _showNow = true;
  double _leftMargin = 0;
  double _topMargin = 0;
  Widget? _child;
  LatLng? _latLng;

  @override
  void initState() {
    widget.controller.addInfoWindow = _addInfoWindow;
    widget.controller.onCameraMove = _onCameraMove;
    widget.controller.hideInfoWindow = _hideInfoWindow;
    widget.controller.updateInfoWindow = _updateOnLatLng;
    super.initState();
  }

  /// Calculate the position on [CustomInfoWindow] and redraw on screen.
  void _updateInfoWindow() async {
    if (_latLng == null ||
        _child == null ||
        widget.controller.googleMapController == null) {
      return;
    }
    ScreenCoordinate screenCoordinate = await widget
        .controller.googleMapController!
        .getScreenCoordinate(_latLng!);
    double devicePixelRatio = GetPlatform.isAndroid ? Get.pixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (widget.offset.dx + widget.width / 2);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio) -
        (widget.offset.dy + widget.height / 2);
    setState(() {
      _showNow = true;
      _leftMargin = left;
      _topMargin = top;
    });
  }

  /// Assign the [Widget] and [Marker]'s [LatLng].
  void _addInfoWindow(Widget child, LatLng latLng) {
    _child = child;
    _latLng = latLng;
    _updateInfoWindow();
  }

  /// Notifies camera movements on [GoogleMap].
  void _onCameraMove() {
    if (!_showNow) return;
    _updateInfoWindow();
  }

  /// Disables [CustomInfoWindow] visibility.
  void _hideInfoWindow() {
    setState(() {
      _showNow = false;
    });
  }

  void _updateOnLatLng(LatLng llng) {
    if (!_showNow) return;
    _latLng = llng;
    _updateInfoWindow();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _leftMargin,
      top: _topMargin,
      child: Visibility(
        visible: (_showNow == false ||
                (_leftMargin == 0 && _topMargin == 0) ||
                _child == null ||
                _latLng == null)
            ? false
            : true,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: _child,
        ),
      ),
    );
  }
}
