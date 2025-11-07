import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/exapndable_tags.dart';
import 'package:archilink/core/widgets/post_actions.dart';
import 'package:archilink/core/widgets/post_body.dart';
import 'package:archilink/core/widgets/post_user_image.dart';
import 'package:archilink/core/widgets/post_username_and_date.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
    this.onPostTapped,
    required this.withDetails,
  });
  final S lang;
  final double width, height;
  final VoidCallback? onPostTapped;
  final bool withDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPostTapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User image section
              PostUserImage(width: width),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name and date section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PostUserNameAndDate(withDetails: withDetails),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              Assets.assetsIconsMoreVertical,
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      // Post body section
                      PostBody(
                        width: width,
                        height: height,
                        withDetails: withDetails,
                      ),
                      SizedBox(height: 16),
                      withDetails? Column(
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
                      ) : SizedBox(),
                      // Post actions section
                      PostActions(width: width),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

