import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post_Details/presentation/manager/bloc/post_details_bloc.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/post_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key, required this.post});

  final PostEntity post;

  static const String name = '/postDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => PostDetailsBloc(post, sl<PostLikeCubit>()),
          child: PostDetailsViewBody(),
        ),
      ),
    );
  }
}
