import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Home/domain/repo/home_repo.dart';
import 'package:archilink/features/Home/presentation/manager/bloc/for_you_bloc.dart';
import 'package:archilink/features/Home/presentation/views/widgets/following_posts_page.dart';
import 'package:archilink/features/Home/presentation/views/widgets/for_you_page.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            MainAppBar(withTabbar: true),
          ],
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              BlocProvider(
                create: (context) =>
                    ForYouBloc(sl<HomeRepo>(), sl<PostLikeCubit>()),
                child: ForYouPage(),
              ),
              FollowingPostsPage(),
              Center(child: Text('saved')),
            ],
          ),
        ),
      ),
    );
  }
}
