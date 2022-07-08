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
                Text(msg, style: const TextStyle(color: Colors.white, fontSize: 20),),
              ],
            ),
          ),
        );
      },
    );
  }
}
