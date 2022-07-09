
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../components/dio_utils.dart';
import '../components/logger_utils.dart';
import 'news_model.dart';

class ChannelItem {
  String title;
  int index;

  ChannelItem(this.title, this.index);
}

class ChannelModel with ChangeNotifier {

  ChannelItem _item = ChannelItem('时政', 0);

  ValueNotifier<List<News>> newsList = ValueNotifier(List.empty());

  ChannelItem get item => _item;

  set item(ChannelItem value) {
    _item = value;
    loadTypeNews(_item.title);
    notifyListeners();
  }

  Future<bool> loadTypeNews(String type) async {
    try {
      Response resp = await DioUtils.getDio().get(
          'http://36.138.192.150:3000/api/news/$type/5');
      List<dynamic> newsJson = resp.data['data']['news'];
      newsList.value = newsJson.map((e) => News.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      Log.d('tag', e);
    }
    return true;
  }
}