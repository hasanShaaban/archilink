import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key});

  static const String name = '/postDetails';

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: PostDetailsViewBody()));
  }
}

class PostDetailsViewBody extends StatelessWidget {
  const PostDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                radius: 24,
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.asset(Assets.assetsIconsBack, color: Theme.of(context).colorScheme.onSurface, width: 24,),
              ),
              SizedBox(width: 26),
              Text('Hasan shaaban\'s ${lang.post}', style: AppTextStyle.interSemiBold16,)
            ],
          ),
        ),
      ],
    );
  }
}
