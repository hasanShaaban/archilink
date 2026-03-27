import 'package:archilink/core/theme/app_theme.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_button.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_user_image.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_username_and_date.dart';
import 'package:flutter/material.dart';
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
                onPressed: () {},
              ),
              CreatePostActionButton(
                icon: Assets.assetsIconsAddImage,
                text: 'Add Photos',
                onPressed: () async {
                  final List? result = await AssetPicker.pickAssets(
                    context,
                    pickerConfig: AssetPickerConfig(
                      requestType: RequestType.image,
                      maxAssets: 10,
                      pageSize: 120,
                      pickerTheme:AppTheme.darkMode
                    ),
                  );
                },
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
    );
  }
}
