import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingNewPost extends StatelessWidget {
  const LoadingNewPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child:
          BlocSelector<CreatePostCubit, CreatePostState, bool>(
            selector: (state) {
              return state.isSubmitting;
            },
            builder: (context, isSubmitting) {
              return isSubmitting
                  ? Column(
                      children: [
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'loading new post...',
                                style: AppTextStyle
                                    .interRegular16
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                              ),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ],
                    )
                  : SizedBox();
            },
          ),
    );
  }
}