import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/global_provider.dart';
import 'components/sound_utils.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/recorder_test.dart';

void main() {
  runApp(const MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle so = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(so);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    SoundUtils.init();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (context) => GlobalProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: Home.name,
        routes: {
          Onboarding.name: (context) => const Onboarding(),
          Home.name: (context) => const Home(),
          RecorderTest.name: (context) => const RecorderTest(),
        },
      ),
    );
  }

}
