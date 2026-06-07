import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SavedPostsListView extends StatelessWidget {
  const SavedPostsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final dummyPosts = [
      PostEntity(
        id: 1,
        body:
            'This is a beautifully designed modern living room. Love the lighting setup!',
        createdAt: DateTime.now(),
        owner: const PostOwnerEntity(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          city: 'New York',
          country: 'USA',
        ),
        tags: const [],
        likesCount: 120,
        commentsCount: 45,
        likedByMe: true,
        mediaItems: const [],
      ),
      PostEntity(
        id: 2,
        body: 'Minimalist workspace inspiration.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        owner: const PostOwnerEntity(
          id: 2,
          name: 'Jane Smith',
          username: 'janesmith',
          city: 'London',
          country: 'UK',
        ),
        tags: const [],
        likesCount: 89,
        commentsCount: 12,
        likedByMe: false,
        mediaItems: const [],
      ),
      PostEntity(
        id: 1,
        body:
            'This is a beautifully designed modern living room. Love the lighting setup!',
        createdAt: DateTime.now(),
        owner: const PostOwnerEntity(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          city: 'New York',
          country: 'USA',
        ),
        tags: const [],
        likesCount: 120,
        commentsCount: 45,
        likedByMe: true,
        mediaItems: const [],
      ),
      PostEntity(
        id: 2,
        body: 'Minimalist workspace inspiration.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        owner: const PostOwnerEntity(
          id: 2,
          name: 'Jane Smith',
          username: 'janesmith',
          city: 'London',
          country: 'UK',
        ),
        tags: const [],
        likesCount: 89,
        commentsCount: 12,
        likedByMe: false,
        mediaItems: const [],
      ),
      PostEntity(
        id: 1,
        body:
            'This is a beautifully designed modern living room. Love the lighting setup!',
        createdAt: DateTime.now(),
        owner: const PostOwnerEntity(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          city: 'New York',
          country: 'USA',
        ),
        tags: const [],
        likesCount: 120,
        commentsCount: 45,
        likedByMe: true,
        mediaItems: const [],
      ),
      PostEntity(
        id: 2,
        body: 'Minimalist workspace inspiration.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        owner: const PostOwnerEntity(
          id: 2,
          name: 'Jane Smith',
          username: 'janesmith',
          city: 'London',
          country: 'UK',
        ),
        tags: const [],
        likesCount: 89,
        commentsCount: 12,
        likedByMe: false,
        mediaItems: const [],
      ),
    ];

    return ListView.separated(
      itemBuilder: (context, index) {
        final savedPost = dummyPosts[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostUserImage(
                    width: width,
                    imageURL: savedPost.owner.profilePictureUrl,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: PostUserNameAndDate(
                                  withDetails: true,
                                  date: savedPost.createdAt.toIso8601String(),
                                  owner: savedPost.owner,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          PostBody(
                            width: width,
                            height: MediaQuery.of(context).size.height,
                            withDetails: false,
                            body: savedPost.body,
                            mediaItems: savedPost.mediaItems,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                Assets.assetsIconsSaveFilled,
                                // ignore: deprecated_member_use
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'go to post',
                                      style: AppTextStyle.interMedium12
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    SvgPicture.asset(
                                      Assets.assetsIconsRightArrow,
                                      // ignore: deprecated_member_use
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: dummyPosts.length,
    );
  }
}
