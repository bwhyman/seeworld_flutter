
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/screens/common/search_bar.dart';

import '../../provider/global_provider.dart';
import 'channel_bar.dart';

class CommonContainer extends StatefulWidget {
  const CommonContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommonContainerState();

}

class _CommonContainerState extends State<CommonContainer> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    Log.d('_CommonContainerState', 'build');
    super.build(context);
    final channelItemProvider = Provider.of<GlobalProvider>(context);
    return Column(
      children: [
        const SizedBox(height: 20),
        const SearchBar(),
        const Expanded(flex: 0, child: MyChannel()),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(channelItemProvider.item.title,
                  style: TextStyle(color: Colors.grey[400], fontSize: 80)),
            )),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}