import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_button.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreatePostViewBody extends StatelessWidget {
  final double width, height;
  const CreatePostViewBody({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        final fallbackOwner = fakePostEntity(id: 0).owner;
        final owner = state.profileData == null
            ? fallbackOwner
            : PostOwnerEntity(
                id: 0,
                name: state.profileData!.name,
                username: state.profileData!.username,
                profilePictureUrl: state.profileData!.profilePictureUrl,
              );
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
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
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(
                  left: 20 + width * 34 / 402 + 8,
                  right: 20,
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: null,
                  onChanged: (text) =>
                      context.read<CreatePostCubit>().onTextChanged(text),
                  decoration: const InputDecoration.collapsed(
                    hintText: "What's on your mind?",
                  ),
                  style: AppTextStyle.interRegular16,
                ),
              ),
              SizedBox(height: 12),
              if (state.selectedAssets.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SelectedImagesListView(
                    height: height,
                    images: state.selectedAssets,
                    width: width,
                  ),
                ),

              Divider(height: 0),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CreatePostActionButton(
                      icon: Assets.assetsIconsAddTags,
                      text: 'Add Tags',
                      onPressed: () {},
                    ),
                    CreatePostActionButton(
                      icon: Assets.assetsIconsAddImage,
                      text: 'Add Photos',
                      onPressed: () =>
                          context.read<CreatePostCubit>().pickImages(context),
                    ),
                    CreatePostActionButton(
                      icon: Assets.assetsIconsAddLocation,
                      text: 'Add Location',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SelectedImagesListView extends StatelessWidget {
  const SelectedImagesListView({
    super.key,
    required this.height,
    required this.images,
    required this.width,
  });

  final List<AssetEntity> images;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 166 / 874,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 4),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AssetEntityImage(
                  images[index],
                  isOriginal: false,
                  fit: BoxFit.cover,
                  width: width * 150 / 402,
                  height: width * 150 / 402,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => context
                      .read<CreatePostCubit>()
                      .removeAsset(images[index]),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


