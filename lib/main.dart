
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:seeworld_flutter/screens/Favorites/favorites_screen.dart';
import 'package:seeworld_flutter/screens/common/newscomment_screen.dart';
import 'package:seeworld_flutter/screens/reading/booklist_screen.dart';
import 'package:seeworld_flutter/screens/reading/camera_screen.dart';
import 'package:seeworld_flutter/screens/reading/book_screen.dart';
import 'package:seeworld_flutter/screens/common/news_detail_screen.dart';
import 'package:seeworld_flutter/screens/reading/chapter_screen.dart';
import 'package:seeworld_flutter/screens/settings/login_screen.dart';
import 'package:seeworld_flutter/screens/settings/settings_screens.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';


late final CameraDescription _firstCamera;
void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  _firstCamera = cameras.first;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      getPages: [
        GetPage(name: Home.name, page: () => const Home()),
        GetPage(name: CameraScreen.name, page: () => CameraScreen(camera: _firstCamera)),
        GetPage(name: SettingsScreen.name, page: () => const SettingsScreen()),
        GetPage(name: BookListScreen.name, page: () => const BookListScreen()),
        GetPage(name: BookScreen.name, page: () => const BookScreen()),
        GetPage(name: NewsDetailsScreen.name, page: () => const NewsDetailsScreen()),
        GetPage(name: LoginScreen.name, page: () => const LoginScreen()),
        GetPage(name: FavoritesScreen.name, page: () => FavoritesScreen()),
        GetPage(name: ChapterScreen.name, page: () => const ChapterScreen()),
        GetPage(name: NewsCommentScreen.name, page: () => const NewsCommentScreen()),
      ],
      home: const Onboarding(),
    );
  }
}
