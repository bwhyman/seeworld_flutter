
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/book_init.dart';
import 'package:seeworld_flutter/provider/book_model.dart';
import 'package:seeworld_flutter/provider/channel_model.dart';
import 'package:seeworld_flutter/provider/news_model.dart';
import 'package:seeworld_flutter/screens/reading/booklist_screen.dart';
import 'package:seeworld_flutter/screens/reading/camera_screen.dart';
import 'package:seeworld_flutter/screens/reading/book_screen.dart';
import 'package:seeworld_flutter/screens/common/news_detail_screen.dart';
import 'package:seeworld_flutter/screens/settings/login_screen.dart';
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
    BookInit.initBook(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsModel>(
        create: (context) => NewsModel(),
        ),
        ChangeNotifierProvider<ChannelModel>(
          create: (context) => ChannelModel(),
        ),
        ChangeNotifierProvider<BookModel>(
          create: (context) => BookModel(),
        ),
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
          BookListScreen.name: (context) => const BookListScreen(),
          BookScreen.name: (context) => const BookScreen(),
          NewsDetailsScreen.name: (context) => const NewsDetailsScreen(),
          LoginScreen.name: (context) => const LoginScreen(),
        },
      ),
    );
  }
}
