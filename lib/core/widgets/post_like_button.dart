import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool liked = false;
  int likeCount = 1200;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {

              liked = !liked;
              if(liked){
                likeCount += 1;
              }else{
                likeCount -= 1;
              }
            });
          },
          child: SvgPicture.asset(
            liked ? Assets.assetsIconsFilldLike : Assets.assetsIconsLike ,
            color: liked ? null: Theme.of(context).colorScheme.onSurface,
            width: 24,
          ),
        ),
        SizedBox(width: 4),
        Text('$likeCount', style: AppTextStyle.interBold12,)
      ],
    );
  }
}