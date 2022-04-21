
import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrefixPrinter(PrettyPrinter()),
  );

  static const _tag = 'tag-seeworld';

  static void i(String tag, dynamic message) {
    _logger.i('$_tag::$tag::$message');
  }

  static void d(String tag, dynamic message) {
    _logger.i('$_tag::$tag::$message');
  }
}