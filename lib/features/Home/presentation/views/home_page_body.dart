
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: mainAppBar (context ,withTabBar: true, lang: lang),
        body: TabBarView(children: [
          Center(child: Text('for you')),
          Center(child: Text('following')),
          Center(child: Text('saved')),
        ]),
      ),
    );
  }

  
}
