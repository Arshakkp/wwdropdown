import 'package:flutter/material.dart';
import 'package:wwdropdown/src/model/ww_item.dart';
import 'package:wwdropdown/src/utils/_controller_debouncer.dart';
import 'package:wwdropdown/src/utils/_type_def.dart';

class WWOverlayViewApi extends StatefulWidget {
  final InputDecoration? decoration;
  final WWDropdownApi api;
  final int apiLimitCount;
  final VoidCallback onClose;
  final TextStyle? itemTextStyle;
  final WWDropDownItemSelect onSelect;
  final WWDropdownItem? selectedItem;

  const WWOverlayViewApi(
      {super.key,
      this.itemTextStyle,
      this.decoration,
      required this.onSelect,
      required this.onClose,
      required this.api,
      this.apiLimitCount = 10,
      required this.selectedItem});

  @override
  State<WWOverlayViewApi> createState() => _WWOverlayViewState();
}

class _WWOverlayViewState extends State<WWOverlayViewApi> {
  WWDropdownItem? selectedItem;

  late TextEditingController searchController =
      DebouncedTextEditingController(onDebounced: _onSearch);
  bool isFullyLoaded = false;
  List<WWDropdownItem> items = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String value) async {
    items.clear();
    isFullyLoaded = false;
    load();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      load();
    }
  }

  Future<void> load() async {
    if (isFullyLoaded) return;
    var d = await widget.api
        .call(widget.apiLimitCount, items.length, searchController.text);
    if (d.length < widget.apiLimitCount) {
      isFullyLoaded = true;
    }
    items.addAll(d);
    setState(() {});
  }

  @override
  void initState() {
    selectedItem = widget.selectedItem;
    setState(() {});
    load();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void onTap(WWDropdownItem item) {
    selectedItem = item;
    setState(() {});
    widget.onClose();
    widget.onSelect(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: searchController,
          decoration: widget.decoration,
        ),
        const SizedBox(
          height: 7,
        ),
        Expanded(
            child: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 7,
            );
          },
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return InkWell(
              onTap: () {
                onTap(item);
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    items[index].label,
                    style: widget.itemTextStyle,
                  )
                ],
              ),
            );
          },
        ))
      ],
    );
  }
}
