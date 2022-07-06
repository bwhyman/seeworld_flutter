import 'dart:math';

class TtsAnswersUtils {
  static const _unknowns = {
    '我不懂您的意思',
    '您能再说一遍么',
    '没听清您的意思',
    '没听清您的要求',
    '我无法理解您的意图',
    '我没有听清',
    '我没有理解您的意思'
  };
  static const _sorry = {
    '抱歉', '对不起', '非常抱歉'
  };

  static final Random _random = Random();

  static String getUnknowns() {
    var s = _sorry.elementAt(_random.nextInt(_sorry.length));
    var n = _unknowns.elementAt(_random.nextInt(_unknowns.length));
    return '$s$n';
  }

  static const _forUser =  {
    '正在为您',
  };

  static const _updateMsg = {
    '更新'
  };

  static String getUpdate(String channel) {
    var a = _forUser.elementAt(_random.nextInt(_forUser.length));
    var b = _updateMsg.elementAt(_random.nextInt(_updateMsg.length));
    return '$a$b$channel';
  }

  static const _wait = {
    '请稍等'
  };

  static String getWait() {
    var b = _wait.elementAt(_random.nextInt(_wait.length));
    return b;
  }

  static String getCount(int count, String channel) {
    return '加载$count条 $channel信息';
  }
}




