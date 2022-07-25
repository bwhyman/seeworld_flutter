

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/color_provider.dart';
import 'package:seeworld_flutter/provider/sound_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';

class FloatingButtonProvider extends GetxController {
  final SoundProvider _soundProvider = Get.put(SoundProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  var isRGBlinding = Get.put(ColorProvider()).isRGBlinding;
  Widget getFloatingRecordButton({void Function(String)? onRecorded}) {
    return Obx(() {
      return SizedBox(
        width: 95,
        height: 95,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: isRGBlinding.value ?  UI.iconIsRGBlinding : Colors.indigoAccent,
            child: GestureDetector(
              onTapDown: (detail) {
                _soundProvider.record();
                _ttsProvider.getTts().stop();
              },
              onTapUp: (detail) {
                _soundProvider.stop().then((value) {
                  onRecorded!(value!);
                });
              },
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 50,
              ),
            )),
      );
    });
  }
  FloatingActionButtonLocation getFloatingActionButtonLocation() {
    return const _CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.centerDocked, 0, -10);
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