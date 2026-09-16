import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/app_bar_action_button.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Home/presentation/views/widgets/home_page_tap_bar.dart';
import 'package:archilink/features/Chat/presentation/view/chat_list_view.dart';
import 'package:archilink/features/Search/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
    required this.withTabbar,
    this.showSearch,
  });

  final bool withTabbar;
  final bool? showSearch;

  @override
  Widget build(BuildContext context) {
    bool shouldShowSearch = showSearch ?? true;
    try {
      final role =
          context.watch<CurrentUserCubit>().state.role?.toLowerCase().trim();
      final isStore = role == 'store' || role == 'store account';
      if (showSearch == null) {
        shouldShowSearch = !isStore;
      }
    } catch (_) {
      // Fallback if CurrentUserCubit is not in context
    }

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      actionsPadding: EdgeInsets.only(right: 20),
      titleSpacing: 20,
      title: Skeleton.keep(
        child: Text(
          'Archi Link',
          style: AppTextStyle.appTilte.copyWith(height: 1),
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
        ),
      ),
      actions: [
        AppBarActionButton(
          icon: Assets.assetsIconsMail,
          onPress: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(ChatListView.name);
          },
        ),
        if (shouldShowSearch)
          AppBarActionButton(
            icon: Assets.assetsIconsSearch,
            onPress: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(SearchView.name);
            },
          ),
      ],
      bottom: withTabbar
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height * 50 / 874,
              ),
              child: HomePageTapbar(),
            )
          : PreferredSize(preferredSize: Size.zero, child: SizedBox()),
    );
  }
}
