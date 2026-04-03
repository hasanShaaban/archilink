import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainTabController {
  MainTabController() : controller = PersistentTabController(initialIndex: 0);

  final PersistentTabController controller;

  void setIndex(int index) {
    if (controller.index == index) return;
    controller.index = index;
  }
}
