import 'package:flutter/material.dart';
import 'package:seeworld_flutter/components/sound_utils.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/screens/reading/reading.dart';
import 'package:seeworld_flutter/screens/settings/settings.dart';
import 'package:seeworld_flutter/widgets/my_appbar.dart';
import '../components/logger_utils.dart';
import 'common/common.dart';
import 'recommend/recommend.dart';

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
    if(index != 0) {
      FlutterTtsUtils.getTts().stop();
    } else {
      FlutterTtsUtils.speakProceed();
    }
    _currentIndex = index;
    _myPage.jumpToPage(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:MyAppBarUtils.getHomeAppbar(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: 95,
        height: 95,
        child: FloatingActionButton(
            onPressed: () {
            },
            backgroundColor: Colors.indigoAccent,
            child: GestureDetector(
              onTapDown: (detail) {
                SoundUtils.record();
                FlutterTtsUtils.getTts().stop();
              },
              onTapUp: (detail) {
                SoundUtils.stop(context);
              },
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 50,
              ),
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
      const ReadingContainer(),
      const Settings()
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
