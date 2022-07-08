import 'package:dio/dio.dart';

class DioUtils {
  static final Dio _dio = Dio();

  static Dio getDio() {
    return _dio;
  }
}