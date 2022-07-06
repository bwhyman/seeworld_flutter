import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15)
        ),
        child: const TextField(

          decoration: InputDecoration(
            hintText: '七一 系列活动精彩纷呈',
            border: InputBorder.none,
              icon: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                    Icons.search
                ),
              )
          ),
        ),
      ),
    );
  }
}