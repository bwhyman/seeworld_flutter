import 'package:flutter/material.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'dart:developer' as developer;

import 'package:seeworld_flutter/components/sound_utils.dart';

class RecorderTest extends StatefulWidget {
  static const name = '/recorder';

  const RecorderTest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecorderTestState();
}

class _RecorderTestState extends State<RecorderTest> {
  var _result = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Center(
          child: GestureDetector(
            onTapDown: (e) {
              SoundUtils.record();
            },
            onPanCancel: () {
              SoundUtils.stop(context);
            },
            child: TextButton(
              onPressed: () {
                debugPrint('onPressed');
              },
              child: Text('Recoder'),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              SoundUtils.play();
            },
            child: Text('Play'),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: _send,
            child: Text('Send'),
          ),
        ),
        Center(
          child: Text(_result),
        )
      ]),
    );
  }

  _send() async {
    //SoundUtils.stop();
    _result = await SoundUtils.send();
    Log.d('RecorderTest', _result);
    setState(() {});
  }
}
