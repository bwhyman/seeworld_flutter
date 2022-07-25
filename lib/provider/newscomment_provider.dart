import 'package:get/get.dart';
import 'package:seeworld_flutter/components/random_utils.dart';
import 'package:seeworld_flutter/provider/entity.dart';

class NewsCommentProvider extends GetxController {
  var comments = _c.obs;

  static final List<NewsComment> _c = [
    NewsComment(
        content: '以后会越来越好',
        inserttime: '2022-06-22 14:14:12',
        userName: '云云兔',
        avatarUrl: NewsComment.images.elementAt(0)),
    NewsComment(
        content: '刷到最新动态',
        inserttime: '2022-05-18 09:32:19',
        userName: '观察者',
        avatarUrl: NewsComment.images.elementAt(1)),
    NewsComment(
        content: '妙笔生花，意境深远',
        inserttime: '2022-04-19 11:56:36',
        userName: '眼中晚霞',
        avatarUrl: NewsComment.images.elementAt(2))
  ];

  String getCountRead() {
    String r = _pre.elementAt(RandomUtils.getRandomInt(_pre.length));
    r = '$r${comments.length}';
    r = '$r${_end.elementAt(RandomUtils.getRandomInt(_end.length))}。';
    for (int i = 0; i < comments.length; i++) {
      r = '$r第${i + 1}条, 网友${comments[i].userName}${_say.elementAt(RandomUtils.getRandomInt(_say.length))}，${comments[i].content}。';
    }
    return r;
  }

  addComment(NewsComment comment) {
    comments.insert(0, comment);
  }

  static const _pre = {
    '本条新闻共有',
    '当前新闻共有',
  };
  static const _end = {'条评论', '条网友评论', '网友发表评论', '网友留言'};
  static const _say = {'说', '留言', '表示', '回复'};
}
