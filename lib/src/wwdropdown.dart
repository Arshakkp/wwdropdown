import 'package:flutter/material.dart';
import 'package:wwdropdown/src/model/ww_item.dart';
import 'package:wwdropdown/src/utils/_type_def.dart';
import 'package:wwdropdown/src/widgets/_ww_list_item_view.dart';
import 'package:wwdropdown/src/widgets/_ww_overlay.dart';

class WWDropdown extends StatefulWidget {
  final double elevation;
  final double maxPopViewHeight;
  final ShapeBorder? popUpShape;
  final int apiLimitCount;
  final String? hintText;
  final bool isSingleSelect;
  final TextStyle? itemTextStyle;
  final InputDecoration? searchDecoration;
  final WWDropdownItem? selectedItem;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintStyle;
  final WWDropDownItemSelect onSelect;
  final Decoration? decoration;
  final WWDropdownApi api;
  const WWDropdown(
      {super.key,
      this.elevation = 2,
      this.isSingleSelect = false,
      required this.api,
      this.itemTextStyle,
      this.decoration,
      this.hintStyle,
      this.style,
      this.padding,
      required this.onSelect,
      this.searchDecoration,
      this.apiLimitCount = 10,
      this.hintText,
      this.maxPopViewHeight = 200,
      required this.selectedItem,
      this.popUpShape});

  @override
  State<WWDropdown> createState() => _WWDropdownState();
}

class _WWDropdownState extends State<WWDropdown> {
  final GlobalKey key = GlobalKey();
  final LayerLink link = LayerLink();
  WWDropdownItem? selectedItem;
  void onSelect(WWDropdownItem data) {
    selectedItem = data;
    setState(() {});
    widget.onSelect(data);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showWWDropItemOverlayApi(key,
            builder: (close) => WWOverlayViewApi(
                  api: widget.api,
                  onClose: close,
                  onSelect: onSelect,
                  selectedItem: widget.selectedItem,
                  apiLimitCount: widget.apiLimitCount,
                  decoration: widget.searchDecoration,
                  itemTextStyle: widget.itemTextStyle,
                ),
            context: context,
            link: link,
            elevation: widget.elevation,
            maxHeight: widget.maxPopViewHeight,
            shape: widget.popUpShape);
      },
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          key: key,
          decoration: widget.decoration ?? const BoxDecoration(),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(8),
            child: Text(
              selectedItem?.label ?? widget.hintText ?? "",
              style: selectedItem != null ? widget.style : widget.hintStyle,
            ),
          ),
        ),
      ),
    );
  }
}
