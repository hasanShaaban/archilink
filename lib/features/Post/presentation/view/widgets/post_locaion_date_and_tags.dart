import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/domain/entity/tag_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/exapndable_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PostLocationDateAndTags extends StatelessWidget {
  const PostLocationDateAndTags({
    super.key,
    required this.date,
    required this.tags,
  });
  final String date;
  final List<TagEntity> tags;

  @override
  Widget build(BuildContext context) {
    final formatedDate = formatPostDate(date);
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
              formatedDate['date']!,
              style: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(Assets.assetsIconsDot),
            const SizedBox(width: 8),
            Text(
              formatedDate['time']!,
              style: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ExpandableTags(tags: tags.map((e) => e.name).toList()),
        SizedBox(height: 16),
      ],
    );
  }
}

Map<String, String> formatPostDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();

  final dateFormatter = DateFormat('d MMMM yyyy');
  final timeFormatter = DateFormat('hh:mm a');

  return {
    'date': dateFormatter.format(dateTime),
    'time': timeFormatter.format(dateTime),
  };
}
