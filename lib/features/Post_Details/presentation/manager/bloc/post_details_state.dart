part of 'post_details_bloc.dart';

class PostDetailsState extends Equatable {
  final PostEntity post;

  const PostDetailsState({required this.post});

  PostDetailsState copyWith({PostEntity? post}){
    return PostDetailsState(post: post ?? this.post);
  }
  
  @override
  List<Object> get props => [
    post,

  ];
  
}

