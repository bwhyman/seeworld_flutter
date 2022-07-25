

import 'dart:math';

class RandomUtils {
  static final Random _random = Random();
  static int getRandomInt(int max) {
    return _random.nextInt(max);
  }
}