import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostActionButton extends StatelessWidget {
  const PostActionButton({super.key, required this.onTap, required this.icon, required this.withCount, this.count});

  final VoidCallback onTap;
  final SvgPicture icon;
  final bool withCount;
  final int? count; 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: icon,
        ),
        if(withCount && count != null)
        Row(
          children: [
            SizedBox(width: 4),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 30 / 402,
                child: Text('$count', style: AppTextStyle.interBold12))
          ],
        )
      ],
    );
  }
}