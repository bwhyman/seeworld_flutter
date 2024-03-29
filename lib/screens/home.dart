import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/controller/common_controller.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/floatingbutton_provider.dart';
import 'package:seeworld_flutter/provider/record_provider.dart';
import 'package:seeworld_flutter/provider/sound_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
import 'package:seeworld_flutter/screens/common/newscomment_screen.dart';
import 'package:seeworld_flutter/screens/reading/myreading_screen.dart';
import 'package:seeworld_flutter/screens/settings/my_screen.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import '../provider/dialog_provider.dart';
import 'common/common_screen.dart';
import 'recommend/recommend_screen.dart';

class Home extends StatefulWidget {
  static const String name = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FloatingButtonProvider _floatingButtonProvider =
      Get.put(FloatingButtonProvider());
  final SoundProvider _soundUtils = Get.put(SoundProvider());
  final DialogProvider _dialogUtils = Get.put(DialogProvider());
  final RecommendController _recommendController =
      Get.put(RecommendController());
  final CommonController _commonController = Get.put(CommonController());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final PageController _myPage = PageController(initialPage: 0);
  final ColorProvider _colorProvider = Get.put(ColorProvider());
  final BookController _bookController = Get.put(BookController());
  final _currentIndex = 0.obs;

  _change(int index) {
    if (index != 0) {
      _ttsProvider.getTts().stop();
    } else {
      _ttsProvider.speakProceed();
    }
    _currentIndex.value = index;
    _myPage.jumpToPage(index);
  }

  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _soundUtils.init();
    _checkConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        _dialogUtils.showFullDialog('无法连接网络，请确认当前网络状态');
      }
    });
    _recommendController.setTimer();
    _bookController.initBook();
  }

  _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _dialogUtils.showFullDialog('无法连接网络，请确认当前网络状态');
    }
  }

  @override
  void dispose() {
    _myPage.dispose();
    _recommendController.cancelTimer();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var position = Get.arguments;
    position = position ?? 0;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _change(position as int);
    });
    //isRGBlinding = _colorProvider.isRGBlinding;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _widgetProvider.getHomeAppbar(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: _floatingButtonProvider.getFloatingRecordButton(
          onRecorded: _onRecordHome),
      floatingActionButtonLocation:
          _floatingButtonProvider.getFloatingActionButtonLocation(),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 12,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _initIconButtons()[0],
                _initIconButtons()[1],
                const SizedBox(width: 50),
                _initIconButtons()[2],
                _initIconButtons()[3],
              ],
            )),
      ),
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _myPage,
          children: _list(),
        ),
      ),
    );
  }

  List<IconButton> _initIconButtons() {
    List<IconButton> icons = [];
    for (var i = 0; i < 4; i++) {
      IconData icon = Icons.add_to_drive;
      switch (i) {
        case 0:
          icon = Icons.add_to_drive;
          break;
        case 1:
          icon = Icons.newspaper;
          break;
        case 2:
          icon = Icons.menu_book_outlined;
          break;
        case 3:
          icon = Icons.person_outline;
          break;
      }
      icons.add(IconButton(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        icon: Icon(icon,
            color: _currentIndex.value == i
                ? (_colorProvider.isRGBlinding.value ? UI.iconIsRGBlinding : Colors.red)
                : (_colorProvider.isRGBlinding.value ? UI.black : UI.iconColor),
            size: 35),
        onPressed: () => _change(i),
      ));
    }
    return icons;
  }

  List<Widget> _list() {
    return [
      const RecommendContainer(),
      const CommonScreen(),
      MyReadingScreen(),
      Settings()
    ];
  }

  _onRecordHome(String recordText) {
    if (recordText.contains('加载') && recordText.contains('新闻')) {
      String channelTitle = _commonController
          .getChannelBar()
          .firstWhere((element) => recordText.contains(element));
      if (channelTitle.isEmpty) {
        _ttsProvider.getTts().speak('对不起，没有相应新闻类型，请重新尝试');
      }
      _commonController.currentItem.value = _commonController.channelItems
          .firstWhere((element) => channelTitle == element.title);
      _commonController.listNews(channelTitle);
    }
    if (recordText.contains('评论')) {
      Get.toNamed(NewsCommentScreen.name,
          arguments: _recommendController.currentNews.value);
    }
  }
}
