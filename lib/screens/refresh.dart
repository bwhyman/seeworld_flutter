import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/screens/recorder_test.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/global_provider.dart';

import '../components/sound_utils.dart';
import '../components/tts_answers.dart';
import 'common/common.dart';
import 'onboarding.dart';

void main() {
  runApp(const MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle so = const SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(so);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    SoundUtils.init();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (context) => GlobalProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: Home.name,
        routes: {
          Onboarding.name: (context) => const Onboarding(),
          Home.name: (context) => const Home(),
          RecorderTest.name: (context) => const RecorderTest(),
        },
      ),
    );
  }
}

class RecommendContainer extends StatefulWidget {
  const RecommendContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecommendContainerState();
  }
}

class _RecommendContainerState extends State<RecommendContainer>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _controller2 = RefreshController();
  final ScrollController _controller = ScrollController();
  final List<MyItem> _items = [];
  int _firstIndex = 0;
  int _tempIndex = -1;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      _items.add(MyItem('我和我的祖国', 2));
      setState(() {});
    });
    int tempIndex = -1;
    _controller.addListener(() {
      Log.d('controller', _firstIndex);
      // 向下移动
      // y = (controller.offset / 290).floor();
      if (_firstIndex == tempIndex) {
        return;
      }
      //Log.d('controller', _firstIndex);
      FlutterTtsUtils.getTts().speak(_items[_firstIndex].context);
      tempIndex = _firstIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SmartRefresher(
      controller: _controller2,
      onRefresh: _onRefresh,
      header: const WaterDropMaterialHeader(
        backgroundColor: Colors.blueAccent,
        color: Colors.white,
        distance: 80,
      ),
      child: ListView.custom(
          controller: _controller,
          cacheExtent: 0.0,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5),
          childrenDelegate: CustomChildDelegate(
              (builder, index) {
                return Column(children: [
                  Container(
                    constraints: const BoxConstraints(
                        minHeight: 100, maxHeight: 300),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _items[index].context,
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  const Divider()
                ]);
              },
              itemCount: _items.length,

              scrollBack: (int firstIndex, int lastIndex,
                  leadingScrollOffset, trailingScrollOffset) {
                _firstIndex = firstIndex;
              })),
    );
  }

  Future<void> _onRefresh() {
    //FlutterTtsUtils.getTts().speak(getUpdate('推荐') + getWait());
    //FlutterTtsUtils.getTts().setQueueMode(1);
    return Future.delayed(const Duration(seconds: 1), () {
      var l = _items.length;
      var count = 10;
      _items.insertAll(
          0,
          List<MyItem>.generate(
              count, (index) => MyItem('cc${l + index}', index)));
      setState(() {});
      //FlutterTtsUtils.getTts().speak(getCount(count, '推荐'));
      //FlutterTtsUtils.getTts().setQueueMode(0);
      _controller2.refreshCompleted();
      _tempIndex = -1;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _controller2.dispose();
    _controller.dispose();
  }
}


class MyItem {
  String context;
  int index;

  MyItem(this.context, this.index);
}

class CustomChildDelegate extends SliverChildBuilderDelegate {
  Function(int firstIndex, int lastIndex, double leadingScrollOffset,
      double trailingScrollOffset) scrollBack;

  CustomChildDelegate(NullableIndexedWidgetBuilder builder,
      {required int itemCount, required this.scrollBack})
      : super(builder, childCount: itemCount);

  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex,
      double leadingScrollOffset, double trailingScrollOffset) {
    scrollBack(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
    return super.estimateMaxScrollOffset(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}

class Home extends StatefulWidget {
  static const String name = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _myPage = PageController(initialPage: 0);
  int _currentIndex = 0;

  _change(int index) {
    _currentIndex = index;
    _myPage.jumpToPage(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: 95,
        height: 95,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.indigoAccent,
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 50,
            )),
      ),
      floatingActionButtonLocation: const CustomFloatingActionButtonLocation(
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
          icon = Icons.book_online;
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
      const CommonContainer(),
      const Text('333'),
      const Text('444')
    ];
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX;
  final double offsetY;

  const CustomFloatingActionButtonLocation(
      this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
