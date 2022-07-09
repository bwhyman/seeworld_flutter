
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/provider/channel_model.dart';
import 'package:seeworld_flutter/screens/common/common_container.dart';
import 'package:seeworld_flutter/screens/common/search_bar.dart';

import 'channel_bar.dart';

class CommonScreen extends StatefulWidget {
  const CommonScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CommonScreenState();

}

class CommonScreenState extends State<CommonScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ChannelModel ch = Provider.of<ChannelModel>(context, listen: false);
    ch.loadTypeNews('时政');
    return Column(
      children: const [
        SizedBox(height: 20),
        SearchBar(),
        Expanded(flex: 0, child: ChannelList()),
        Expanded(child: CommonContainer())
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}