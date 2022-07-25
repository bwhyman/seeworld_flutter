import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seeworld_flutter/constants/Theme.dart';

class ColorProvider extends GetxController {
  static final box = GetStorage();

  static bool isRGBinding() {
    if (box.read('isRGBlinding') == null) {
      box.write('isRGBlinding', false);
      return false;
    }
    return box.read('isRGBlinding');
  }

  var isRGBlinding = isRGBinding().obs;

  void setRGBinding(bool result) {
    isRGBlinding.value = result;
    box.write('isRGBinding', result);
  }

  Color getIconColor() {
    return isRGBlinding.value
        ? UI.iconIsRGBlinding
        : UI.iconColor;
  }

  Color getFontColor(bool check) {
    return check
        ? isRGBlinding.value
            ? UI.iconIsRGBlinding
            : Colors.red
        : isRGBlinding.value
            ? Colors.black
            : Colors.blue;
  }
  Color getNewsType() {
    return isRGBlinding.value
        ? UI.iconIsRGBlinding
        : UI.newTypeColor;
  }
}
