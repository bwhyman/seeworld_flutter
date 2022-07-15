
import 'package:flutter/material.dart';
import 'package:seeworld_flutter/screens/common/common_container.dart';
import 'package:seeworld_flutter/screens/common/search_bar.dart';

import 'channel_bar.dart';

class CommonScreen extends StatefulWidget {
  const CommonScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommonScreenState();

}

class _CommonScreenState extends State<CommonScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(height: 20),
        const SearchBar(),
        Expanded(flex: 0, child: ChannelList()),
        Expanded(child: CommonContainer())
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
