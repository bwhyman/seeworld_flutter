import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/sound_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/controller/recommend_controller.dart';
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
  final SoundProvider _soundUtils = Get.put(SoundProvider());
  final DialogProvider _dialogUtils = Get.put(DialogProvider());
  final RecommendController _recommendController =
      Get.put(RecommendController());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final PageController _myPage = PageController(initialPage: 0);
  int _currentIndex = 0;

  _change(int index) {
    if (index != 0) {
      _ttsProvider.getTts().stop();
    } else {
      _ttsProvider.speakProceed();
    }
    _currentIndex = index;
    _myPage.jumpToPage(index);
    setState(() {});
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _widgetProvider.getHomeAppbar(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: 95,
        height: 95,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.indigoAccent,
            child: GestureDetector(
              onTapDown: (detail) {
                _soundUtils.record();
                _ttsProvider.getTts().stop();
              },
              onTapUp: (detail) {
                _soundUtils.stop();
              },
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 50,
              ),
            )),
      ),
      floatingActionButtonLocation:
      const _CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 0, -10),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 12,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _initIconButtons()[0],
            _initIconButtons()[1],
            const SizedBox(width: 50),
            _initIconButtons()[2],
            _initIconButtons()[3],
          ],
        ),
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
            color: _currentIndex == i ? Colors.red : Colors.blue, size: 35),
        onPressed: () => _change(i),
      ));
    }
    return icons;
  }

  _list() {
    return [
      const RecommendContainer(),
      const CommonScreen(),
      const MyReadingScreen(),
      const Settings()
    ];
  }
}

class _CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX;
  final double offsetY;

  const _CustomFloatingActionButtonLocation(
      this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
