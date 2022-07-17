import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/controller/favorites_controller.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';

class FavoritesScreen extends StatelessWidget {
  static const name = '/FavoritesScreen';
  FavoritesScreen({Key? key}) : super(key: key);
  final WidgetProvider _appBarProvider = Get.put(WidgetProvider());
  final FavoritesController _favoritesController =
      Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var favoritesList = _favoritesController.favoritesList;
    return Scaffold(
      appBar: _appBarProvider.getTitleAppbar('收藏'),
      body: Obx(() => ListView.separated(
        itemCount: favoritesList.length,
        itemBuilder: (c, index) => ListTile(
          leading: const Icon(
            Icons.favorite_outline,
            color: Colors.blue,
          ),
          title: Text(favoritesList[index].title!, style: const TextStyle(fontSize: 22)),
          subtitle: Text(favoritesList[index].insertTime!),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          onTap: () {
            Get.toNamed('', arguments: favoritesList[index]);
          },
        ),
        separatorBuilder: (_, __) => const Divider(),
      )),
    );
  }
}
