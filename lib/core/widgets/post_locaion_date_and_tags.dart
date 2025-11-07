import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/exapndable_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostLocationDateAndTags extends StatelessWidget {
  const PostLocationDateAndTags({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              Assets.assetsIconsLocation,
              color: Theme.of(context).colorScheme.tertiary,
              width: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Homs,Syria',
              style: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
        SizedBox(height: 13),
        Row(
          children: [
            Text(
              '3 October 2025',
              style: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(Assets.assetsIconsDot),
            const SizedBox(width: 8),
            Text(
              '08:50 PM',
              style: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ExpandableTags(
          tags: [
            'Revit',
            '3D Max',
            'Auto CAD',
            'Graduation Project Assist',
            'Architecture',
            'Design',
            'Inspiration',
            '3DModeling',
            'SketchUp',
            'Sustainability',
            'Interior',
            'Urban',
            'Concrete',
            'Minimalism',
            'Render',
            'Lighting',
            'Landscape',
          ],
        ),
        SizedBox(height: 16)
      ],
    );
  }
}

