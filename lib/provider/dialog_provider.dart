import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogProvider extends GetxController {
  showFullDialog(String msg) {
    showDialog(
      context: Get.context!,
      builder: (_) {
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
      builder: (_) {
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

  addDialog(TextEditingController controller, String title, String hintText, Function onPressed) {
    showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (_) {
        return SimpleDialog(
          title: Text(title),
          elevation: 24,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(hintText: hintText),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            onPressed();
                          },
                          child: const Text('保存')),
                    )
                  ],
                ))
          ],
        );
      },
    );
  }

  deleteDialog(String description, String title, Function onPressed) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('警告'),
            elevation: 24,
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: description,
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: title,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(
                                text: '?',
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              onPressed();
                            },
                            child: const Text('删除')),
                      )
                    ],
                  ))
            ],
          );
        });
  }

  editDialog(TextEditingController controller, String title, Function onPressed) {
    showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (_) {
        return SimpleDialog(
          title: Text(title),
          elevation: 24,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            onPressed();
                          },
                          child: const Text('保存')),
                    )
                  ],
                ))
          ],
        );
      },
    );
  }

  addComment(TextEditingController controller, String title, Function onPressed) {
    showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (_) {
        return SimpleDialog(
          title: Text(title),
          elevation: 24,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            onPressed();
                          },
                          child: const Text('提交')),
                    )
                  ],
                ))
          ],
        );
      },
    );
  }
  showTutorialDialog(bool checked) {
    showDialog(
      context: Get.context!,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent, // 设置透明背影
          body: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(8.0),
            height: 500,
            width: double.infinity,
            child: Card(
              child: Column(
                children: [
                  Text('教程'),
                  CheckboxListTile(
                    title: Text('不再提示'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: checked,
                      onChanged: (_) {
                        checked != checked;
                      }
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
