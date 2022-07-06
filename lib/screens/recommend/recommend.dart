import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/components/sound_utils.dart';
import 'package:seeworld_flutter/components/tts_utils.dart';
import 'package:seeworld_flutter/provider/news.dart';
import 'package:seeworld_flutter/screens/recommend/recommend_container.dart';

import 'package:seeworld_flutter/components/logger_utils.dart';

class RecommendContainer extends StatefulWidget {
  const RecommendContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecommendContainerState();
  }
}

class _RecommendContainerState extends State<RecommendContainer>
    with AutomaticKeepAliveClientMixin {

  final ScrollController _controller = ScrollController();
  int _firstIndex = 0;
  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    FlutterTtsUtils.getTts().stop();
    super.dispose();
  }

  init() {
    Future.delayed(Duration.zero, () => _newsModel.loadNews(context).then((value) => {
      FlutterTtsUtils.speakNews(_newsModel.listNews()[0])
    }));
  }

  double _pointY = 0;
  double _pointX = 0;
  static const _distY = 150;
  static const _scrollDuration = 500;
  static double _containerH = 615;
  static const double _dividerH = 2;
  static const _doubleTapTime = 300;
  static const _distX = 150;
  bool _ttsPause = false;
  late NewsModel _newsModel;
  int _pointerDown = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    _containerH = height - 24 - 95;
    _newsModel = Provider.of<NewsModel>(context);
    return Listener(
      onPointerDown: (event) {
        _pointY = event.position.dy;
        _pointX = event.position.dx;
        int temp = DateTime.now().millisecondsSinceEpoch;
        if(temp - _pointerDown <= _doubleTapTime) {
          if(_ttsPause) {
            // resume
            Log.d('_ttsPause', 'resume');
          } else {
            FlutterTtsUtils.getTts().stop();
          }
          _ttsPause = !_ttsPause;
        }
        _pointerDown = temp;
        return;
      },
      onPointerUp: (event) {
        int index = -1;
        bool speak = false;
        // horizontal
        // right
        if (event.position.dx > _pointX) {
          if (event.position.dx - _pointX > _distX) {
            Log.d('_distX', 'to right');
            //SoundUtils.playSeek(true);
            FlutterTtsUtils.speakSeek();
            return;
          }
          // left
        } else if (event.position.dx < _pointX) {
          if (_pointX - event.position.dx > _distX) {
            Log.d('_distX', 'to left');
            FlutterTtsUtils.speakSeek(forward: false);
            return;
          }
        }

        // vertical
        if (event.position.dy > _pointY) {
          if (event.position.dy - _pointY > _distY) {
            speak = true;
            index = _firstIndex;
          } else {
            speak = false;
            index = _lastIndex;
          }
        } else if (event.position.dy < _pointY) {
          if (_pointY - event.position.dy > _distY) {
            speak = true;
            index = _lastIndex;
          } else {
            speak = false;
            index = _firstIndex;
          }
        }
        if (index == -1) {
          return;
        }
        if(index <= _newsModel.listNews().length - 1) {
          _newsModel.loadNews(context);
        }

        _controller
            .animateTo(index * (_containerH + _dividerH),
                duration: const Duration(milliseconds: _scrollDuration),
                curve: Curves.easeInOutCubic)
            .then((value) => {
                  if (speak) {
                      // tts读取
                      FlutterTtsUtils.speakNews(_newsModel.listNews()[index])
                    }
                });
      },
      child: Consumer<NewsModel>(
        builder: (context, newModel, w) {
          return ListView.custom(
              controller: _controller,
              cacheExtent: 0.0,
              physics: const AlwaysScrollableScrollPhysics(),
              childrenDelegate: CustomChildDelegate(
                  (builder, index) {
                    return Column(children: [
                      SizedBox(
                          height: _containerH,
                          child: RecommendNewsContainer(newModel.listNews()[index])),
                      const Divider(height: _dividerH)
                    ]);
                  },
                  itemCount: newModel.listNews().length,
                  scrollBack: (int firstIndex, int lastIndex,
                      leadingScrollOffset, trailingScrollOffset) {
                    _firstIndex = firstIndex;
                    _lastIndex = lastIndex;
                    //Log.d('tag', '$_firstIndex / $_lastIndex');
                  }));
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MyItem {
  String context;

  MyItem(this.context);
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
    //Log.d('scrollBack', 'leadingScrollOffset: $leadingScrollOffset and trailingScrollOffset: $trailingScrollOffset');
    return super.estimateMaxScrollOffset(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}

const content = """
""";
