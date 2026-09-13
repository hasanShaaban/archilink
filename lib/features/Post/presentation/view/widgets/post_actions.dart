// ignore_for_file: deprecated_member_use

import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_save_cubit.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_action_button.dart';
import 'package:archilink/features/Post/presentation/view/widgets/save_to_collection_bottom_sheet.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PostActions extends StatelessWidget {
  const PostActions({
    super.key,
    required this.width,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
    required this.postId,
  });

  final double width;
  final int likesCount, commentsCount, postId;
  final bool likedByMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PostLikeButton(
                liked: likedByMe,
                likesCount: likesCount,
                postId: postId,
              ),
              SizedBox(width: width * 25 / 402),
              PostCommentButton(commentsCount: commentsCount),
            ],
          ),
          // PostShareButton(),
          PostSaveButton(postId: postId),
        ],
      ),
    );
  }
}

class PostLikeButton extends StatelessWidget {
  final int postId, likesCount;
  final bool liked;
  const PostLikeButton({
    super.key,
    required this.postId,
    required this.likesCount,
    required this.liked,
  });

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      count: likesCount,
      withCount: true,
      onTap: () {
        context.read<PostLikeCubit>().toggleLike(
          postId: postId,
          liked: liked,
          likeCount: likesCount,
        );
      },
      icon: SvgPicture.asset(
        liked ? Assets.assetsIconsFilldLike : Assets.assetsIconsLike,
        color: liked ? null : Theme.of(context).colorScheme.onSurface,
        width: 24,
      ),
    );
  }
}

class PostCommentButton extends StatelessWidget {
  const PostCommentButton({super.key, required this.commentsCount});

  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      onTap: () {},
      withCount: true,
      count: commentsCount,
      icon: SvgPicture.asset(
        Assets.assetsIconsComment,
        color: Theme.of(context).colorScheme.onSurface,
        width: 24,
      ),
    );
  }
}

class PostShareButton extends StatelessWidget {
  const PostShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      onTap: () {},
      icon: SvgPicture.asset(
        Assets.assetsIconsSharePost,
        width: 24,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      withCount: false,
    );
  }
}

class PostSaveButton extends StatelessWidget {
  final int postId;

  const PostSaveButton({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final isSaved = context.select<PostSaveCubit, bool>(
      (cubit) => cubit.isPostSaved(postId),
    );

    return BlocListener<PostSaveCubit, PostSaveState>(
      listenWhen: (previous, current) {
        if (current is PostSaveSuccess && current.postId == postId) return true;
        if (current is PostUnsaveSuccess && current.postId == postId)
          return true;
        if (current is PostSaveFailure && current.postId == postId) return true;
        return false;
      },
      listener: (context, state) {
        if (state is PostSaveSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is PostUnsaveSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is PostSaveFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: PostActionButton(
        onTap: () async {
          if (isSaved) {
            context.read<PostSaveCubit>().unsavePost(postId: postId);
            return;
          }

          final selectedCollection =
              await showModalBottomSheet<UserCollectionEntity>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (bottomSheetContext) => BlocProvider(
                  create: (_) => sl<UserCollectionsCubit>()..fetchCollections(),
                  child: const SaveToCollectionBottomSheet(),
                ),
              );

          if (!context.mounted) return;

          if (selectedCollection != null) {
            context.read<PostSaveCubit>().savePost(
              postId: postId,
              collectionId: selectedCollection.id,
              collectionTitle: selectedCollection.title,
            );
          } else {
            // User skipped choosing specific collection (like tap outside the bottom sheet)
            // The manager will use the id of the default collection
            context.read<PostSaveCubit>().savePost(postId: postId);
          }
        },
        icon: SvgPicture.asset(
          isSaved ? Assets.assetsIconsSaveFilled : Assets.assetsIconsSave,
          width: 24,
          color: isSaved ? null : Theme.of(context).colorScheme.onSurface,
        ),
        withCount: false,
      ),
    );
  }
}
