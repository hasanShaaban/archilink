import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/app_bar_action_button.dart';
import 'package:archilink/features/Home/presentation/views/widgets/home_page_tap_bar.dart';
import 'package:archilink/features/chat/presentation/view/chat_view.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key, required this.withTabbar,
  });

  final bool withTabbar;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      actionsPadding: EdgeInsets.only(right: 20),
      titleSpacing: 20,
      title: Text(
        'Archi Link',
        style: AppTextStyle.appTilte.copyWith(height: 1),
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: false,
        ),
      ),
      actions: [
        AppBarActionButton(
          icon: Assets.assetsIconsMail,
          onPress: () {
            Navigator.of(context, rootNavigator: true).pushNamed(ChatView.name);
          },
        ),
        AppBarActionButton(
          icon: Assets.assetsIconsSearch,
          onPress: () {},
        ),
      ],
      bottom: withTabbar? PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 50 / 874,
        ),
        child: HomePageTapbar(),
      ): PreferredSize(preferredSize: Size.zero, child: SizedBox()),
    );
  }
}

