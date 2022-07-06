import 'package:flutter/material.dart';

class MyDialogUtils {
  static showLoading(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent, // 设置透明背影
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('loading'),
              ],
            ),
          ),
        );
      },
    );
  }
}
