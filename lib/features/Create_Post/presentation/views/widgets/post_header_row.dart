import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:flutter/material.dart';

class PostHeaderRow extends StatelessWidget {
  const PostHeaderRow({
    super.key,
    required this.width,
    required this.owner, required this.state,
  });

  final double width;
  final PostOwnerEntity owner;
  final CreatePostState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          PostUserImage(
            width: width,
            imageURL: state.profileData?.profilePictureUrl,
          ),
          SizedBox(width: 8),
          PostUserNameAndDate(
            withDetails: false,
            date: DateTime.now().toIso8601String(),
            owner: owner,
          ),
        ],
      ),
    );
  }
}