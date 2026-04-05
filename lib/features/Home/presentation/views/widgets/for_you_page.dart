import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/fakers.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:archilink/features/Home/domain/entity/feed_item.dart';
import 'package:archilink/features/Home/presentation/manager/bloc/for_you_bloc.dart';
import 'package:archilink/features/Home/presentation/views/widgets/ads_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_section.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    context.read<ForYouBloc>().add(LoadInitital());
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 150) {
      context.read<ForYouBloc>().add(LoadMore());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ForYouBloc>().add(RefreshFeed());
      },
      child: BlocBuilder<ForYouBloc, ForYouState>(
        builder: (context, state) {
          final bool isSkeleton = state.isInitialLoading && state.items.isEmpty;
          final List<FeedItem> items = isSkeleton
              ? fakeFeedItems()
              : state.items;
          final String? errorMessage = state.failure?.message;
          return CustomScrollView(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: const AdsSection()),
              SliverToBoxAdapter(child: const FeaturedMemberSection()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(lang.feed, style: AppTextStyle.manjariRegular20),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = items[index];

                  if (item is PostItem) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Skeletonizer(
                            effect: ShimmerEffect(
                              highlightColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.5),
                              baseColor: AppColorsFromTheme.grayForTheme(
                                context,
                              ).withOpacity(0.5),
                            ),
                            enabled: isSkeleton,
                            child: Post(
                              entity: item.post,
                              lang: lang,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              onPostTapped: isSkeleton
                                  ? null
                                  : () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushNamed(
                                        PostDetailsView.name,
                                        arguments: {'post': item.post},
                                      );
                                    },
                              withDetails: false,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                }, childCount: items.length),
              ),

              if (errorMessage != null && items.isEmpty && !isSkeleton)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 36,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.manjariRegular20.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              /// LOADING MORE INDICATOR
              if (state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
