
import 'package:flutter/foundation.dart';
import 'package:seeworld_flutter/screens/common/channel_bar.dart';

class GlobalProvider with ChangeNotifier {

  ChannelItem _item = ChannelItem('', 0);

  late ValueNotifier<int> _pageIndexNotifier = ValueNotifier(0);

  ChannelItem get item => _item;
  set item(ChannelItem value) {
    _item = value;
    notifyListeners();
  }

  ValueNotifier<int> get pageIndexNotifier => _pageIndexNotifier;

  set pageIndexNotifier(ValueNotifier<int> value) {
    _pageIndexNotifier = value;
    notifyListeners();
  }
}