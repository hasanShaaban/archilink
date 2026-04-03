import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Home/presentation/views/home_page_body.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/profile_page_body.dart';
import 'package:archilink/features/Main/presentation/views/widgets/nav_bar_icon_and_label.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainViewBody extends StatefulWidget {
  const MainViewBody({super.key});

  @override
  State<MainViewBody> createState() => _MainViewBodyState();
}

// Section: State class for the main view
class _MainViewBodyState extends State<MainViewBody> {
  late final MainTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = sl<MainTabController>();
  }

  // Section: List of pages
  final List<Widget> _pages = [
    HomePageBody(),
    Center(child: Text('store')), //TODO: store page
    ProfilePageBody(type: ProfileType.personalProfile),
    Center(child: Text('settings')), //TODO: Setting page
  ];

  // Section: Navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context, S lang) {
    return [
      navigationBarItem(
        context,
        image: Assets.assetsIconsHome,
        title: lang.home,
      ),
      navigationBarItem(
        context,
        image: Assets.assetsIconsShoppingBasket,
        title: lang.store,
      ),
      navigationBarItem(
        context,
        image: Assets.assetsIconsUser,
        title: lang.profile,
      ),
      navigationBarItem(
        context,
        image: Assets.assetsIconsSettings,
        title: lang.settings,
      ),
    ];
  }

  // Section: Build method for the main view
  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return PersistentTabView(
      decoration: NavBarDecoration(
        border: Border(
          top: BorderSide(
            color: AppColorsFromTheme.lightGray(context),
            width: 0.2,
          ),
        ),
      ),
      context,
      screens: _pages,
      controller: _tabController.controller,
      items: _navBarsItems(context, lang),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      onItemSelected: (value) {
        if (value == 2) {
          BlocProvider.of<ProfileCubit>(context).getPersonlProfile();
          BlocProvider.of<ProfileBloc>(context).add(LoadInitialProfilePosts());
        }
      },
      navBarStyle: NavBarStyle.style13,
    );
  }
}

// Section: Helper method for creating navigation bar items
PersistentBottomNavBarItem navigationBarItem(
  BuildContext context, {
  required String image,
  required String title,
  Function(BuildContext?)? onPressed,
}) {
  return PersistentBottomNavBarItem(
    onPressed: onPressed,
    inactiveIcon: NavBarIconAndLabel(
      alignment: MainAxisAlignment.end,
      color: Theme.of(context).colorScheme.onSurface,
      image: image,
      title: title,
    ),
    icon: NavBarIconAndLabel(
      alignment: MainAxisAlignment.center,
      color: Theme.of(context).colorScheme.primary,
      image: image,
      title: title,
    ),
    title: (title),
    activeColorPrimary: Theme.of(context).colorScheme.primary,
    inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
  );
}
