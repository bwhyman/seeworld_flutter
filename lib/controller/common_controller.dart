import 'package:get/get.dart';
import 'package:seeworld_flutter/components/baseurl_utils.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
import 'package:seeworld_flutter/provider/entity.dart';

class ChannelItem {
  String title;


  ChannelItem(this.title);
}

class _ChannelProvider extends GetConnect {
  static const _baseUrl = BaseUrlUtils.baseUrl;
  Future<List<News>> loadTypeNews(String type) async {
    Response resp = await get('${_baseUrl}news/$type/5');
    List<dynamic> newsJson = resp.body['data']['news'];
    return newsJson.map((e) => News.fromJson(e)).toList();
  }
}

class CommonController extends GetxController {
  final _ChannelProvider _channelProvider = Get.put(_ChannelProvider());
  var currentItem = ChannelItem('时政').obs;
  var commonNews = <News>[].obs;

  List<ChannelItem> channelItems = _get();

  Future<RxList<News>> listNews(String type) async {
    var l = await _channelProvider.loadTypeNews(type);
    commonNews.clear();
    commonNews.addAll(l);
    return commonNews;
  }
  Set<String> getChannelBar() {
    return _titles;
  }
  static List<ChannelItem> _get() {
    return List.generate(
        _titles.length, (index) => ChannelItem(_titles.elementAt(index)));
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
