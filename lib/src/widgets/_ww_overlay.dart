import 'package:flutter/material.dart';

void showWWDropItemOverlayApi(GlobalKey key,
    {required Function(VoidCallback close) builder,
    required BuildContext context,
    double maxHeight = 200,
    double elevation = 2,
    ShapeBorder? shape,
    required LayerLink link}) {
  RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  var targetPostion = renderBox.localToGlobal(Offset.zero);
  var widgetHeight = renderBox.size.height;
  var screenHeight = MediaQuery.of(context).size.height;
  var isAbove = targetPostion.dy + widgetHeight + 200 > screenHeight;

  late OverlayEntry overlayEntry;
  void onClose() {
    overlayEntry.remove();
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        left: targetPostion.dx,
        top: isAbove
            ? targetPostion.dy - maxHeight
            : targetPostion.dy + widgetHeight,
        child: TapRegion(
          onTapOutside: (event) {
            overlayEntry.remove();
          },
          child: CompositedTransformFollower(
            link: link,
            offset: Offset(0, isAbove ? -maxHeight : widgetHeight),
            child: Material(
              elevation: elevation,
              shape: shape,
              child: SizedBox(
                width: renderBox.size.width,
                height: maxHeight,
                child: builder(onClose),
              ),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(overlayEntry);
}
