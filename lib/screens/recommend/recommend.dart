import 'package:flutter/material.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';

import '../../components/logger_utils.dart';
import '../../components/tts_answers.dart';
import '../../data_test.dart';

class RecommendContainer extends StatefulWidget {
  const RecommendContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecommendContainerState();
  }
}

class _RecommendContainerState extends State<RecommendContainer>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller = ScrollController();
  final List<MyItem> _items = [];
  int _firstIndex = 0;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      _items.add(MyItem('cc', 2));
      setState(() {});
    });
    int tempIndex = -1;
    controller.addListener(() {
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
    //Log.d('_RecommendContainerState', 'build');
    return RefreshIndicator(
      onRefresh: _onRefresh,
      displacement: 100,
      strokeWidth: 3,
      color: Colors.white,
      backgroundColor: Colors.teal,
      child: ListView.custom(
          cacheExtent: 0.0,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          padding: const EdgeInsets.all(5),
          childrenDelegate: CustomChildDelegate(
                  (builder, index) {
                return Container(
                  constraints:
                  const BoxConstraints(minHeight: 100, maxHeight: 300),
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
                );
              },
              itemCount: _items.length,
              scrollBack: (int firstIndex, int lastIndex) {
                _firstIndex = firstIndex;
                Log.d('scrollBack', '$firstIndex and $lastIndex');
              })),
    );
  }


  Future<void> _onRefresh() {
    FlutterTtsUtils.getTts().speak(getUpdate('推荐') + getWait());
    FlutterTtsUtils.getTts().setQueueMode(1);
    return Future.delayed(const Duration(seconds: 1), () {
      var l = _items.length;
      var count = 10;
      _items.insertAll(
          0, List<MyItem>.generate(count, (index) => MyItem('cc${l + index}', index)));
      setState(() {});
      FlutterTtsUtils.getTts().speak(getCount(count, '推荐'));
      FlutterTtsUtils.getTts().setQueueMode(0);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class MyItem {
  String context;
  int index;

  MyItem(this.context, this.index);
}
class CustomChildDelegate extends SliverChildBuilderDelegate {
  Function(int firstIndex, int lastIndex) scrollBack;

  CustomChildDelegate(NullableIndexedWidgetBuilder builder,
      {required int itemCount, required this.scrollBack})
      : super(builder, childCount: itemCount);

  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex,
      double leadingScrollOffset, double trailingScrollOffset) {
    scrollBack(firstIndex, lastIndex);
    //Log.d('scrollBack', 'firstIndex: $firstIndex and lastIndex: $lastIndex');
    return super.estimateMaxScrollOffset(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}