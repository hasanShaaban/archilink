import 'package:archilink/features/Post/presentation/view/widgets/post_actions.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_body.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_locaion_date_and_tags.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_menu_button.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum PostMenuAction { edit, delete, hide, report, interest }

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
    this.onPostTapped,
    required this.withDetails,
    required this.entity,
    this.localAssets = const [],
  });
  final S lang;
  final double width, height;
  final VoidCallback? onPostTapped;
  final bool withDetails;
  final PostEntity entity;
  final List<AssetEntity> localAssets;

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
                  final myUsername = context
                      .read<CurrentUserCubit>()
                      .state
                      .username;
                  final isMine =
                      myUsername != null && myUsername == entity.owner.username;
                  if (isMine) {
                    context.read<ProfileCubit>().getPersonlProfile();
                    BlocProvider.of<ProfileBloc>(
                      context,
                    ).add(LoadInitialProfilePosts());
                    sl<MainTabController>().setIndex(2);
                    return;
                  }
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(UserProfileView.name);
                  context.read<ProfileCubit>().getUserProfile(
                    entity.owner.username,
                  );
                  BlocProvider.of<ProfileBloc>(context).add(
                    LoadInitialProfilePosts(username: entity.owner.username),
                  );
                },
                child: PostUserImage(
                  width: width,
                  imageURL: entity.owner.profilePictureUrl,
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
                            date: entity.createdAt.toString(),
                            owner: entity.owner,
                          ),
                          //----------------// Post more options section //--------------------------------------------------------
                          PostMenuButton(username: entity.owner.username),
                        ],
                      ),
                      const SizedBox(height: 9),
                      //--------------------// Post body section //---------------------------------------------------------------
                      PostBody(
                        body: entity.body,
                        mediaItems: entity.mediaItems,
                        localAssets: localAssets,
                        width: width,
                        height: height,
                        withDetails: withDetails,
                      ),
                      SizedBox(height: 16),
                      withDetails
                          ? PostLocationDateAndTags(
                              date: entity.createdAt.toString(),
                              tags: entity.tags,
                              city: entity.owner.city,
                              country: entity.owner.country,
                            )
                          : SizedBox(),
                      //--------------------// Post actions section //------------------------------------------------------------
                      PostActions(
                        width: width,
                        postId: entity.id,
                        likesCount: entity.likesCount,
                        commentsCount: entity.commentsCount,
                        likedByMe: entity.likedByMe,
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
