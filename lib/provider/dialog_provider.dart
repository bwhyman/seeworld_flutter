import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogProvider extends GetxController {
  showFullDialog(String msg) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent, // 设置透明背影
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  msg,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSimpleDialog(String msg) {
    showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (context) {
        return SimpleDialog(
          title: const Text('警告'),
          elevation: 24,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20),
                height: 50,
                child: Text(
                  msg,
                  style: const TextStyle(fontSize: 16),
                ))
          ],
        );
      },
    );
  }
}
