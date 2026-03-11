import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_actions.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_locaion_date_and_tags.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
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
    required this.entity,
  });
  final S lang;
  final double width, height;
  final VoidCallback? onPostTapped;
  final bool withDetails;
  final PostEntity? entity;

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
              //------------// User image section //-------------------------------------------------------------------------
              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(UserProfileView.name);
                },
                child: PostUserImage(
                  width: width,
                  imageURL: entity!.owner.profilePictureUrl,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //--------------------// User name and date section //--------------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PostUserNameAndDate(
                            withDetails: withDetails,
                            date: entity!.createdAt.toString(),
                            owner: entity!.owner,
                          ),
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
                      //--------------------// Post body section //---------------------------------------------------------------
                      PostBody(
                        body: entity!.body,
                        mediaItems: entity!.mediaItems,
                        width: width,
                        height: height,
                        withDetails: withDetails,
                      ),
                      SizedBox(height: 16),
                      withDetails ? PostLocationDateAndTags(date: entity!.createdAt.toString(), tags: entity!.tags,) : SizedBox(),
                      //--------------------// Post actions section //------------------------------------------------------------
                      PostActions(
                        width: width,
                        postId: entity!.id,
                        likesCount: entity!.likesCount,
                        commentsCount: entity!.commentsCount,
                        likedByMe: entity!.likedByMe,
                      ),
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
