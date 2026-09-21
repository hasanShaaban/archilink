
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/create_post_view_body.dart';
import 'package:archilink/features/Create_Post/presentation/views/widgets/post_button.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key, this.postToEdit});
  final PostEntity? postToEdit;
  static const name = '/createPost';

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<CreatePostCubit>();
      if (widget.postToEdit != null) {
        cubit.initForEdit(widget.postToEdit!);
      } else {
        cubit.initForCreate();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: BlocSelector<CreatePostCubit, CreatePostState, bool>(
          selector: (state) => state.isEditMode,
          builder: (context, isEditMode) {
            return Text(
              isEditMode ? 'Edit Post' : 'New Post',
              style: AppTextStyle.interSemiBold16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            );
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          PostButton(width: width, height: height),
          const SizedBox(width: 20),
        ],
      ),
      body: BlocListener<CreatePostCubit, CreatePostState>(
        listenWhen: (previous, current) =>
            previous.updateSuccess != current.updateSuccess ||
            (previous.failure != current.failure && current.failure != null),
        listener: (context, state) {
          if (state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure!.message)),
            );
          } else if (state.updateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post updated successfully')),
            );
            Navigator.of(context).pop(true);
          }
        },
        child: SafeArea(
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
