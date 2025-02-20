import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wwdropdown/src/model/ww_item.dart';
import 'package:wwdropdown/src/utils/_type_def.dart';
import 'package:wwdropdown/src/widgets/_ww_list_item_view.dart';
import 'package:wwdropdown/src/widgets/_ww_overlay.dart';

class WWDropdown extends StatefulWidget {
  final double elevation;
  final double maxPopViewHeight;
  final ShapeBorder? popUpShape;
  final int apiLimitCount;
  final TextStyle? itemTextStyle;
  final InputDecoration? searchDecoration;
  final List<WWDropdownItem> selectedItems;
  final Function(List<WWDropdownItem> items) onSelect;
  final InputDecoration? decoration;
  final WWDropdownApi api;
  const WWDropdown(
      {super.key,
      this.elevation = 2,
      required this.api,
      this.itemTextStyle,
      this.decoration,
      required this.onSelect,
      this.searchDecoration,
      this.apiLimitCount = 10,
      this.maxPopViewHeight = 200,
      required this.selectedItems,
      this.popUpShape});

  @override
  State<WWDropdown> createState() => _WWDropdownState();
}

class _WWDropdownState extends State<WWDropdown> {
  final GlobalKey key = GlobalKey();
  final LayerLink link = LayerLink();
  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      readOnly: true,
      decoration: widget.decoration,
      onTap: () {
        showWWDropItemOverlayApi(key,
            child: WWOverlayViewApi(
              api: widget.api,
              onSelect: widget.onSelect,
              selectedItems: widget.selectedItems,
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
    );
  }
}
