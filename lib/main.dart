
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/global_provider.dart';
import 'package:seeworld_flutter/provider/news.dart';
import 'package:seeworld_flutter/screens/reading/book_favorites.dart';
import 'package:seeworld_flutter/screens/reading/camera.dart';
import 'package:seeworld_flutter/screens/reading/charlotte_web.dart';
import 'package:seeworld_flutter/screens/recommend/news_detail_screen.dart';
import 'package:seeworld_flutter/screens/settings/settings_screens.dart';
import 'components/sound_utils.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/recorder_test.dart';

late final CameraDescription _firstCamera;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  _firstCamera = cameras.first;

  runApp(const MyApp());
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
        ChangeNotifierProvider<NewsModel>(
        create: (context) => NewsModel(),
        ),
        ChangeNotifierProvider<GlobalProvider>(
          create: (context) => GlobalProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Onboarding.name,
        routes: {
          Onboarding.name: (context) => const Onboarding(),
          Home.name: (context) => const Home(),
          RecorderTest.name: (context) => const RecorderTest(),
          TakePictureScreen.name: (context) => TakePictureScreen(camera: _firstCamera),
          SettingsScreen.name: (context) => const SettingsScreen(),
          BookFavoritiesScreen.name: (context) => const BookFavoritiesScreen(),
          CharlotteWebScreen.name: (context) => const CharlotteWebScreen(),
          NewsDetailsScreen.name: (context) => NewsDetailsScreen(),
        },
      ),
    );
  }
}
