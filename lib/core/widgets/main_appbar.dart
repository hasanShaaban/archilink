import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/app_bar_action_button.dart';
import 'package:archilink/features/Home/presentation/views/widgets/home_page_tap_bar.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
  });

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
        'Acrhi Link',
        style: AppTextStyle.appTilte.copyWith(height: 1),
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: false,
        ),
      ),
      actions: [
        AppBarActionButton(
          icon: Assets.assetsIconsMail,
          onPress: () {},
        ),
        AppBarActionButton(
          icon: Assets.assetsIconsSearch,
          onPress: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 50 / 874,
        ),
        child: HomePageTapbar(),
      ),
    );
  }
}

