import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wwdropdown/src/widgets/_ww_list_item_view.dart';
import 'package:wwdropdown/src/widgets/_ww_overlay.dart';

class WWDropdown extends StatefulWidget {
  final double elevation;
  final double maxPopViewHeight;
  final ShapeBorder? popUpShape;
  const WWDropdown(
      {super.key,
      this.elevation = 2,
      this.maxPopViewHeight = 200,
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
      onTap: () {
        showWWDropItemOverlayApi(key,
            child: WWOverlayViewApi(
              api: (limit, skip, search) async {
                return [];
              },
              onSelect: (selected) {},
              selectedItem: [],
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
