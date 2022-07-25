import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/floatingbutton_provider.dart';
import 'package:seeworld_flutter/provider/newscomment_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/screens/home.dart';

class NewsCommentScreen extends StatefulWidget {
  static const name = "/NewsCommentScreen";

  const NewsCommentScreen({Key? key}) : super(key: key);

  @override
  State<NewsCommentScreen> createState() => _NewsCommentScreenState();
}

class _NewsCommentScreenState extends State<NewsCommentScreen> {
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final DialogProvider _dialogProvider = Get.put(DialogProvider());
  final FloatingButtonProvider _floatingButtonProvider =
      Get.put(FloatingButtonProvider());
  final NewsCommentProvider _commentProvider = Get.put(NewsCommentProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final TextEditingController _editingController = TextEditingController();
  late News _news;
  final List<NewsComment> _comments = Get.put(NewsCommentProvider()).comments;

  @override
  void initState() {
    super.initState();
    _ttsProvider.speakContent(_commentProvider.getCountRead());
  }

  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _news = Get.arguments as News;
    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar(_news.title, items: [
        _widgetProvider.getIconButton(Icons.comment_outlined,
            onPressed: _replay)
      ]),
      floatingActionButton: _floatingButtonProvider.getFloatingRecordButton(
          onRecorded: _onRecord),
      floatingActionButtonLocation:
          _floatingButtonProvider.getFloatingActionButtonLocation(),
      body: Obx(() => GestureDetector(
            onDoubleTap: () => _ttsProvider.getTts().stop(),
            child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _comments[index].avatarUrl != null
                                  ? Image.network(
                                      _comments[index].avatarUrl!,
                                      width: 60,
                                      height: 60,
                                    )
                                  : Image.asset(
                                      'assets/imgs/logo.png',
                                      width: 80,
                                      height: 80,
                                    )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_comments[index].userName!),
                            Text(_comments[index].content!,style: TextStyle(fontSize: UI.newsContentFontSize),),
                            Text(_comments[index].inserttime!),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          )),
    );
  }

  bool _sayContent = false;
  String _content = '';

  _onRecord(String resultText) {
    if (!_sayContent && resultText.contains('评论')) {
      _content = resultText.substring(resultText.indexOf('评论') + 2);
      _content = _content.replaceAll('，', '').replaceAll(',', '');
      _ttsProvider.speakContent('您预发布的评论内容是，$_content，您确定发布么？');
      _sayContent = true;
      return;
    }
    _sayContent = false;
    if (resultText.contains('是的') ||
        resultText.contains('确定') ||
        resultText.contains('发吧')) {
      if (_content.isEmpty) {
        return;
      }
      NewsComment c = _getComment(_content);
      _commentProvider.addComment(c);
      _content = '';
      _ttsProvider.speakContent(_commentProvider.getCountRead());
    }
  }

  _replay() {
    _dialogProvider.addComment(_editingController, '添加评论', _addComment);
  }

  _addComment() {
    NewsComment c = _getComment(_editingController.text);
    Future.delayed(const Duration(seconds: 3), () {
      _commentProvider.addComment(c);
      _ttsProvider.speakContent(_commentProvider.getCountRead());
      Get.back();
    });
  }

  _getComment(String comm) {
    return NewsComment(
        userName: '游客81',
        content: comm,
        inserttime:
            DateTime.now().toString().replaceAll('T', ' ').substring(0, 19));
  }
}
