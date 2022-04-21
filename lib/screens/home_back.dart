/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/logger_utils.dart';
import '../provider/global_provider.dart';
import 'bottom/bottom.dart';
import 'common/common.dart';
import 'recommend/recommend.dart';

class Home extends StatefulWidget {
  static const String name = '/home';

  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Log.d('_homeState', 'initState');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Log.d('_homeState', 'build');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.indigoAccent,
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 40,
            )),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 0, -10),
      bottomNavigationBar: const MyBottomBar(),
      body: _MainContainer(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _MainContainer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MainContainerState();
}

class _MainContainerState extends State<_MainContainer> with AutomaticKeepAliveClientMixin {
  static const recommend = RecommendContainer();
  static const common = CommonContainer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<GlobalProvider>(context);
    return ValueListenableBuilder(
      valueListenable: provider.pageIndexNotifier,
      builder: (BuildContext context, int value, Widget? child) {
        Widget r;
        switch(value) {
          case 0:
            r = recommend;
            break;
          case 1:
            r = common;
            break;
          case 2:
            r = Text('333');
            break;
          case 3:
            r = Text('444');
            break;
          default:
            r = recommend;
            break;
        }
        return r;
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
*/
