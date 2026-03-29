
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_action_buttons.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_text_field.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/post_header_row.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/selected_images_list_view.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              PostHeaderRow(width: width, owner: owner, state: state,),
              SizedBox(height: 12),
              CreatePostTextFiled(width: width),
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
              CreatePostActionButtons(),
            ],
          ),
        );
      },
    );
  }
}










