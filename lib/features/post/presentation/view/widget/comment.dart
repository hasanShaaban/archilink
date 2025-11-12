
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: width * 34 / 402 / 2,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: ClipOval(
                  child: SvgPicture.asset(
                    //change it to Cached Network Image
                    Assets.assetsIconsUser, //---------------image
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 24,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hasan shaaban',
                          style: AppTextStyle.interMedium14.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          
                        ),
                        Text(' 2h', style:AppTextStyle.interMedium14.copyWith(color: Theme.of(context).colorScheme.tertiary),),
                        Spacer(),
                        SvgPicture.asset(Assets.assetsIconsLike, color: Theme.of(context).colorScheme.onSurface, width: 16,)
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Honestly, I think this update was a huge improvement overall. The new UI feels smoother and way more consistent across different devices, especially on smaller screens. I really like how the transitions have been handled — they feel natural instead of forced. However,',
                      style: AppTextStyle.mallannaRegular14.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: width * 50 / 402,
                child: Divider(
                  indent: 17,
                  height: 0,
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('Reply', style: AppTextStyle.interMedium12.copyWith(color: Theme.of(context).colorScheme.tertiary),),
              ),
              Expanded(
                child: Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            Text('Show Replies', style: AppTextStyle.interMedium12.copyWith(color: Theme.of(context).colorScheme.tertiary),),
            SizedBox(width: 4),
            SvgPicture.asset(Assets.assetsIconsDownArrow, color: Theme.of(context).colorScheme.tertiary, width: 16,)
          ])
        ],
      ),
    );
  }
}
