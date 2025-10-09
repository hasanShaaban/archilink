import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Home/presentation/views/home_page_body.dart';
import 'package:archilink/features/main/presentation/views/widgets/nav_bar_icon_and_label.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}
// Section: State class for the main view
class _MainViewState extends State<MainView> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  // Section: List of pages
  final List<Widget> _pages = [
    HomePageBody(),
    Center(child: Text('store')),//TODO: store page
    Center(child: Text('profile')),//TODO: profile page
    Center(child: Text('settings')),//TODO: Setting page
  ];

  // Section: Navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      navigationBarItem(context, image: Assets.assetsIconsHome, title: 'Home'),
      navigationBarItem(
        context,
        image: Assets.assetsIconsShoppingBasket,
        title: 'Store',
      ),
      navigationBarItem(
        context,
        image: Assets.assetsIconsUser,
        title: 'profile',
      ),
      navigationBarItem(
        context,
        image: Assets.assetsIconsSettings,
        title: 'Settings',
      ),
    ];
  }

  // Section: Build method for the main view
  @override
  Widget build(BuildContext context) {
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
      controller: _controller,
      items: _navBarsItems(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,

      navBarStyle: NavBarStyle.style13,
    );
  }
}

// Section: Helper method for creating navigation bar items
PersistentBottomNavBarItem navigationBarItem(
  BuildContext context, {
  required String image,
  required String title,
}) {
  return PersistentBottomNavBarItem(
    inactiveIcon: NavBarIconAndLabel(
      alignment: MainAxisAlignment.end,
      color: Theme.of(context).colorScheme.onSurface,
      image: image,
      title: title,
    ),
    icon: NavBarIconAndLabel(
      alignment: MainAxisAlignment.end,
      color: Theme.of(context).colorScheme.primary,
      image: image,
      title: title,
    ),
    title: ("Home"),
    activeColorPrimary: Theme.of(context).colorScheme.primary,
    inactiveColorPrimary: Theme.of(context).colorScheme.onSurface,
  );
}


