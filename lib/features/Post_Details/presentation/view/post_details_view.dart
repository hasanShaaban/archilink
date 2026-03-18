import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post_Details/data/models/reply_target.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:archilink/features/Post_Details/presentation/manager/bloc/post_details_bloc.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/comment_text_field.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/post_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsView extends StatefulWidget {
  const PostDetailsView({super.key, required this.post});

  final PostEntity post;

  static const String name = '/postDetails';

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  late ReplyTarget _replyTarget;
  final FocusNode _commentFocus = FocusNode();

  @override
  void initState() {
    _replyTarget = ReplyTarget(username: widget.post.owner.name);
    super.initState();
  }

  void _onReply(CommentEntity comment) {
    setState(() {
      _replyTarget = ReplyTarget(
        username: comment.owner.name,
        commentId: comment.id,
      );
    });
    _commentFocus.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyTarget = ReplyTarget(username: widget.post.owner.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailsBloc(
        widget.post,
        sl<PostLikeCubit>(),
        sl<PostDetailsRepo>(),
      )..add(LoadComments()),
      child: Scaffold(
        bottomNavigationBar: CommentTextField(
          replyTarget: _replyTarget,
          commentFocus: _commentFocus,
          onCancelReply: _cancelReply,
        ),
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (_replyTarget.isReply) {
                _cancelReply();
              }
            },
            child: PostDetailsViewBody(onReply: _onReply),
          ),
        ),
      ),
    );
  }
}
