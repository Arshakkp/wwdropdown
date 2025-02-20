import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedTextEditingController extends TextEditingController {
  Timer? _debounce;
  final Function(String) onDebounced;

  // Constructor that accepts the debounced callback function
  DebouncedTextEditingController({
    required this.onDebounced,
  });

  @override
  set text(String newText) {
    super.text = newText;
    _onTextChanged(
        newText); // Call the debounce function whenever the text changes
  }

  // Method to handle the debounce behavior
  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel(); // Cancel any existing timer
    }
    // Set a new timer to invoke the callback after 500ms of inactivity
    _debounce = Timer(const Duration(milliseconds: 500), () {
      onDebounced(query); // Call the callback function after the delay
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the timer when the controller is disposed
    super.dispose();
  }
}
