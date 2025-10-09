import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePageTapbar extends StatefulWidget {
  const HomePageTapbar({
    super.key,
  });

  @override
  State<HomePageTapbar> createState() => _HomePageTapbarState();
}

class _HomePageTapbarState extends State<HomePageTapbar> {
  int seleted = 0;
  @override
  Widget build(BuildContext context) {
    
    var lang = S.of(context);
    return TabBar(
      onTap: (value) => {
        setState(() {
          seleted = value;
        })
      },
      isScrollable: true,
        physics: BouncingScrollPhysics(),
        indicatorWeight: 1,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
        labelStyle: AppTextStyle.mallannaRegular20,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Theme.of(context).colorScheme.primary,
    
        tabs: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Tab(text: lang.forYou),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Tab(text: lang.following),
          ),
          Tab(
            child: SvgPicture.asset(
              Assets.assetsIconsNotification,
              width: 24,
              color:seleted == 2 ?
               Theme.of(context).colorScheme.primary:
               Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      );
  }
}
