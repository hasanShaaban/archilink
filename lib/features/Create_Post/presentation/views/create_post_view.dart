import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});
  static const name = '/createPost';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => CreatePostCubit(sl<MediaPickerService>()),
      child: Scaffold(
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
            BlocSelector<CreatePostCubit, CreatePostState, bool>(
              selector: (state) => state.canPost,
              builder: (context, canPost) {
                return Center(
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
                        backgroundColor: canPost
                            ? Theme.of(context).colorScheme.primary
                            : AppColorsFromTheme.grayForTheme(context),
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                      ),
                      child: Text('Post', style: AppTextStyle.interMedium16),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 20),
          ],
        ),

        body: SafeArea(
          child: CreatePostViewBody(width: width, height: height),
        ),
      ),
    );
  }
}
