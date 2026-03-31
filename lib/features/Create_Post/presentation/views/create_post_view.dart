import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_view_body.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/post_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});
  static const name = '/createPost';

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => CreatePostCubit(
        mediaPickerService: sl<MediaPickerService>(),
        createPostRepo: sl<CreatePostRepo>(),
      ),
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
            PostButton(width: width, height: height),
            SizedBox(width: 20),
          ],
        ),

        body: SafeArea(
          child: CreatePostViewBody(
            width: width,
            height: height,
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }
}

