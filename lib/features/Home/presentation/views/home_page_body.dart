
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Home/presentation/views/widgets/for_you_page.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            MainAppBar(),
          ],
          body: TabBarView(
            children: [
              ForYouPage(),
              Center(child: Text('following')),
              Center(child: Text('saved')),
            ],
          ),
        ),
      ),
    );
  }
}


