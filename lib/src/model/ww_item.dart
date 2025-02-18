import 'package:flutter/widgets.dart';

class WWDropdownItem<T extends Object> {
  final String label;
  T value;
  WWDropdownItem({required this.label, required this.value});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WWDropdownItem &&
          runtimeType == other.runtimeType &&
          value == other.value;
  @override
  int get hashCode => value.hashCode;
}
