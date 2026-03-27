import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});
  static const name = '/createPost';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: AppTextStyle.interSemiBold16.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          Center(
            child: SizedBox(
              width: width * 83 / 402,
              height: height * 44 / 874,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
                child: Text('Post', style: AppTextStyle.interMedium16),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),

      body: SafeArea(
        child: CreatePostViewBody(width: width, height: height),
      ),
    );
  }
}

class CreatePostViewBody extends StatelessWidget {
  final double width, height;
  const CreatePostViewBody({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            PostUserImage(width: width),
            SizedBox(width: 8),
            PostUserNameAndDate(
              withDetails: false,
              date: DateTime.now().toIso8601String(),
              owner: fakePostEntity(id: 0).owner,
            ),
          ],
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height * 0.16),
            child: TextField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration.collapsed(
                hintText: "What's on your mind?",
              ),
              style: AppTextStyle.interRegular16,
            ),
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
              ),
              CreatePostActionButton(
                icon: Assets.assetsIconsAddImage,
                text: 'Add Photos',
              ),
              CreatePostActionButton(
                icon: Assets.assetsIconsAddLocation,
                text: 'Add Location',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CreatePostActionButton extends StatelessWidget {
  final String icon, text;
  const CreatePostActionButton({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AppColorsFromTheme.grayForTheme(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () {},
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyle.interMedium12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
