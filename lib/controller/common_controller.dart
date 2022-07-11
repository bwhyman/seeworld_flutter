import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';

class ChannelItem {
  String title;
  int index;

  ChannelItem(this.title, this.index);
}

class _ChannelProvider extends GetConnect {
  Future<List<News>> loadTypeNews(String type) async {
    Response resp = await get('http://36.138.192.150:3000/api/news/$type/5');
    List<dynamic> newsJson = resp.body['data']['news'];
    return newsJson.map((e) => News.fromJson(e)).toList();
  }
}

class CommonController extends GetxController {
  final _ChannelProvider _channelProvider = Get.put(_ChannelProvider());
  var currentItem = ChannelItem('时政', 0).obs;
  var commonNews = <News>[].obs;

  List<ChannelItem> channelItems = List.generate(
      _titles.length, (index) => ChannelItem(_titles.elementAt(index), index));

  Future<bool> listNews(String type) async {
    var l = await _channelProvider.loadTypeNews(type);
    commonNews.clear();
    commonNews.addAll(l);
    return true;
  }
}

const _titles = {
  '时政',
  '社会',
  '财经',
  '体育',
  '娱乐',
  '房产',
  '彩票',
  '教育',
  '时尚',
  '游戏',
  '科技',
  '股票',
  '星座',
  '家居',
};
