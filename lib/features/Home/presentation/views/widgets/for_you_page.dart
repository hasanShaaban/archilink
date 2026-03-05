import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/post.dart';
import 'package:archilink/features/Home/domain/entity/feed_item.dart';
import 'package:archilink/features/Home/presentation/manager/bloc/for_you_bloc.dart';
import 'package:archilink/features/Home/presentation/views/widgets/ads_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/featured_member_section.dart';
import 'package:archilink/features/Home/presentation/views/widgets/post_section.dart';
import 'package:archilink/features/Post/presentation/view/post_details_view.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 300) {
      context.read<ForYouBloc>().add(LoadMore());
    }
  }

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
          return CustomScrollView(
            controller: _controller,
            slivers: [
              SliverToBoxAdapter(child: const AdsSection()),
              SliverToBoxAdapter(child: const FeaturedMemberSection()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(lang.feed, style: AppTextStyle.manjariRegular20),
                ),
              ),

              /// POSTS
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = state.items[index];

                  if (item is PostItem) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Post(
                            lang: lang,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            onPostTapped: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(PostDetailsView.name);
                            },
                            withDetails: false,
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
                }, childCount: state.items.length),
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
