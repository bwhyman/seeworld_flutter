import 'package:flutter/material.dart';

class MyDialogUtils {
  static showMyDialog(context, String msg) {
    showDialog(
      context: context,
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

  static showSimpleDialog(context, String msg) {
    showDialog(
      barrierDismissible: true,
      context: context,
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
