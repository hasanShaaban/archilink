
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/main/presentation/views/widgets/app_bar_action_button.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 27),
        titleSpacing: 27,
        title: Text(
          'Acrhi Link',
          style: AppTextStyle.appTilte.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          AppBarActionButton(icon: Assets.assetsIconsMail, onPress: () {}),
          AppBarActionButton(icon: Assets.assetsIconsSearch, onPress: () {}),
        ],
      ),
    );
  }
}

