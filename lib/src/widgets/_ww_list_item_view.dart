import 'package:flutter/material.dart';
import 'package:wwdropdown/src/model/ww_item.dart';
import 'package:wwdropdown/src/utils/_controller_debouncer.dart';
import 'package:wwdropdown/src/utils/_type_def.dart';
import 'package:flutter/services.dart'; // For keyboard events

class WWOverlayViewApi extends StatefulWidget {
  final InputDecoration? decoration;
  final WWDropdownApi api;
  final int apiLimitCount;
  final TextStyle? itemTextStyle;
  final WWDropDownItemSelect onSelect;
  final WWDropdownItem? selectedItem;

  const WWOverlayViewApi(
      {super.key,
      this.itemTextStyle,
      this.decoration,
      required this.onSelect,
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

  // Track the currently focused item index
  int focusedIndex = 0;

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
    widget.onSelect(item);
  }

  // Handle keyboard events to navigate up and down
  void handleKeyPress(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (focusedIndex < items.length - 1) {
        setState(() {
          focusedIndex++;
        });
        _scrollToIndex(focusedIndex);
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (focusedIndex > 0) {
        setState(() {
          focusedIndex--;
        });
        _scrollToIndex(focusedIndex);
      }
    }
  }

  // Scroll to a specific index
  void _scrollToIndex(int index) {
    double position = index * 60.0; // Assuming each item has height ~60.0
    _scrollController.animateTo(position,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode()
        ..requestFocus(), // Request focus for keyboard events
      onKey: handleKeyPress, // Set up keypress handling
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: widget.decoration,
          ),
          const SizedBox(
            height: 7,
          ),
          Expanded(
            child: ListView.builder(
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
                      Checkbox(
                        value: item == selectedItem,
                        onChanged: (value) {
                          onTap(item);
                        },
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        item.label,
                        style: widget.itemTextStyle,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
