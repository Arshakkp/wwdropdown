import 'package:wwdropdown/src/model/ww_item.dart';

typedef WWDropdownApi = Future<List<WWDropdownItem>> Function(
    int limit, int skip, String? search);
typedef WWDropDownItemSelect = void Function(WWDropdownItem selected);
