
import 'package:flutter/services.dart';

MethodChannel _channel = MethodChannel("com.example.speex");

callBack() async {
  String result = await _channel.invokeMethod("getResult", "params");
  print("getResult: " + result);
}