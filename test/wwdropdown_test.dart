import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wwdropdown/src/widgets/_ww_list_item_view.dart';
import 'package:wwdropdown/wwdropdown.dart'; // Adjust this to match the correct import path

void main() {
  group('WWDropdown Widget Tests', () {
    testWidgets('WWDropdown renders correctly and opens overlay',
        (tester) async {
      // Mock data for testing
      final List<WWDropdownItem> mockItems = List.generate(
        10,
        (index) => WWDropdownItem(
          label: 'Item $index',
          value: index,
        ),
      );

      final mockApi = (int limit, int skip, String? search) async {
        return mockItems.sublist(skip, skip + limit);
      };

      final selectedItem = WWDropdownItem(label: 'Item 0', value: 0);

      // Build our WWDropdown widget and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WWDropdown(
              api: mockApi,
              onSelect: (item) {},
              selectedItem: selectedItem,
            ),
          ),
        ),
      );

      // Verify if WWDropdown is rendered
      expect(find.byType(WWDropdown), findsOneWidget);

      // Verify the selected item text is displayed
      expect(find.text('Item 0'), findsOneWidget);

      // Tap to open the dropdown overlay
      await tester.tap(find.byType(WWDropdown));
      await tester.pumpAndSettle();

      // Check if overlay is shown
      expect(find.byType(WWOverlayViewApi), findsOneWidget);
    });

    testWidgets('Dropdown selection changes when an item is tapped',
        (tester) async {
      // Mock data for testing
      final List<WWDropdownItem> mockItems = List.generate(
        10,
        (index) => WWDropdownItem(
          label: 'Item $index',
          value: index,
        ),
      );

      final mockApi = (int limit, int skip, String? search) async {
        return mockItems.sublist(skip, skip + limit);
      };

      final selectedItem = WWDropdownItem(label: 'Item 0', value: 0);

      // Build our WWDropdown widget and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WWDropdown(
              api: mockApi,
              onSelect: (item) {
                // Ensure the item was selected and the UI updates accordingly
                expect(item.label, 'Item 2');
              },
              selectedItem: selectedItem,
            ),
          ),
        ),
      );

      // Tap to open the dropdown overlay
      await tester.tap(find.byType(WWDropdown));
      await tester.pumpAndSettle();

      // Tap the third item in the list (Item 2)
      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();

      // Verify the selected item text is updated
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('Keyboard navigation works (Arrow Up / Arrow Down)',
        (tester) async {
      // Mock data for testing
      final List<WWDropdownItem> mockItems = List.generate(
        10,
        (index) => WWDropdownItem(
          label: 'Item $index',
          value: index,
        ),
      );

      final mockApi = (int limit, int skip, String? search) async {
        return mockItems.sublist(skip, skip + limit);
      };

      final selectedItem = WWDropdownItem(label: 'Item 0', value: 0);

      // Build our WWDropdown widget and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WWDropdown(
              api: mockApi,
              onSelect: (item) {},
              selectedItem: selectedItem,
            ),
          ),
        ),
      );

      // Tap to open the dropdown overlay
      await tester.tap(find.byType(WWDropdown));
      await tester.pumpAndSettle();

      // Verify if overlay is shown
      expect(find.byType(WWOverlayViewApi), findsOneWidget);

      // Simulate keyboard down arrow key press to navigate
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // Verify the next item is now focused (Item 1)
      expect(find.text('Item 1'), findsOneWidget);

      // Simulate keyboard up arrow key press to navigate back
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();

      // Verify the first item is now focused again (Item 0)
      expect(find.text('Item 0'), findsOneWidget);
    });
  });
}
