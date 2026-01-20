import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChatListAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleText: 'Chats',
      titleTextStyle: AppTextStyle.interSemiBold24.copyWith(color: Theme.of(context).colorScheme.onSurface),
      centerTitle: false,
      actions: [
        IconButton(
          icon: SvgPicture.asset(Assets.assetsIconsMenu, color: Theme.of(context).colorScheme.onSurface,),
          onPressed: () {
            //TODO:handle menu actions
          },
        ),
      ],
    );
  }
}