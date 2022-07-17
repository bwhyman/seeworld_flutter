import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';

class LoginScreen extends StatefulWidget {
  static const name = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _userNameFN = FocusNode();
  final FocusNode _pwdFN = FocusNode();
  final DialogProvider _dialogUtils = Get.put(DialogProvider());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar('登录'),
      body: GestureDetector(
        onTap: () {
          _userNameFN.unfocus();
          _pwdFN.unfocus();
        },
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 16, bottom: 36),
              child: Image.asset('assets/imgs/logo.png'),
              height: 230,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Form(
                child: Column(
                  children: [
                    TextField(
                      focusNode: _userNameFN,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: '请输入手机号',
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {},
                          )),
                    ),
                    TextField(
                      focusNode: _pwdFN,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: '请输入密码',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {},
                          )),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  _dialogUtils.showFullDialog('');
                  Future.delayed(const Duration(seconds: 4), () {
                    Navigator.pop(context);
                    _dialogUtils.showSimpleDialog('用户名密码错误');
                  });
                },
                child: const Text('登录'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const Text('第三方登录'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Image.asset('assets/imgs/weixin.png'),
                        height: 60,
                      ),
                      SizedBox(
                        child: Image.asset('assets/imgs/QQ.png'),
                        height: 50,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {}, child: const Text('忘记密码')),
                  TextButton(onPressed: () {}, child: const Text('快速注册'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
