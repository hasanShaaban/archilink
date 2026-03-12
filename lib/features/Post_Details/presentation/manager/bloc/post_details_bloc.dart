import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_details_event.dart';
part 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final PostLikeCubit interactions;
  PostDetailsBloc(PostEntity post, this.interactions)
    : super(PostDetailsState(post: post)) {
    interactions.stream.listen((event) {
      if (event == null) return;

      add(
        SyncPostLike(
          postId: event.postId,
          liked: event.liked,
          likesCont: event.likeCount,
        ),
      );
    });

    on<ToggleLikePost>(_onToggleLike);
    on<SyncPostLike>(_onSyncPostLike);
  }

  void _onToggleLike(ToggleLikePost event, Emitter<PostDetailsState> emit) {
    interactions.toggleLike(
      postId: state.post.id,
      liked: state.post.likedByMe,
      likeCount: state.post.likesCount,
    );
  }

  void _onSyncPostLike(SyncPostLike event, Emitter<PostDetailsState> emit) {
    if (event.postId != state.post.id) return;

    emit(
      state.copyWith(
        post: state.post.copyWith(
          likedByMe: event.liked,
          likesCount: event.likesCont,
        ),
      ),
    );
  }
}
