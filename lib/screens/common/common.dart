
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/screens/common/common_container.dart';
import 'package:seeworld_flutter/screens/common/search_bar.dart';

import '../../provider/global_provider.dart';
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
    return Column(
      children: const [
        SizedBox(height: 20),
        SearchBar(),
        Expanded(flex: 0, child: MyChannel()),
        Expanded(child: CommonContainer())
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}