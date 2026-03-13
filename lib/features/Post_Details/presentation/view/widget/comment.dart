// ignore_for_file: deprecated_member_use

import 'package:archilink/core/functions/post_date_formater.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/presentation/view/widget/comment_like_button.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.width,
    this.indent = 0,
    required this.entity,
  });

  final double width;

  final double indent;
  final CommentEntity entity;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool _showReplies = false;

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: lang.local == 'en' ? widget.indent : 0,
        right: lang.local == 'ar' ? widget.indent : 0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: widget.width * 34 / 402 / 2,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: ClipOval(
                  child: SvgPicture.asset(
                    //change it to Cached Network Image
                    Assets
                        .assetsIconsUser, //====================================image
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 24,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  //==================================================user name and comment body
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          //---------------------------------------------------user name
                          widget.entity.owner.name,
                          style: AppTextStyle.interMedium14.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          //--------------------------------------------------comment date
                          ' ${formatPostDate(widget.entity.createdAt)}',
                          style: AppTextStyle.interMedium14.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Spacer(),
                        CommentLikeButton(
                          isLiked: widget.entity.likedByMe,
                          likeCount: widget.entity.likesCount,
                        ), // -----------------------------------like button
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      // -----------------------------------------------------comment body
                      widget.entity.body,
                      style: AppTextStyle.mallannaRegular14.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: widget.width * 50 / 402,
                child: Divider(
                  indent: 17,
                  height: 0,
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Reply',
                  style: AppTextStyle.interMedium12.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          widget.entity.repliesCount > 0
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _showReplies = !_showReplies;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _showReplies
                            ? 'Hide Replies'
                            : 'Show ${widget.entity.repliesCount} Replies',
                        style: AppTextStyle.interMedium12.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 4),
                      SvgPicture.asset(
                        _showReplies
                            ? Assets.assetsIconsUpArrow
                            : Assets.assetsIconsDownArrow,
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 16,
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          //TODO: add the replies in separate request
          // AnimatedCrossFade(
          //   firstChild: const SizedBox.shrink(),
          //   secondChild: Column(
          //     children: replies
          //         .map(
          //           (reply) => Container(
          //             decoration: BoxDecoration(
          //               border: Border(
          //                 left: lang.local == 'en'
          //                     ? BorderSide(
          //                         color: Theme.of(
          //                           context,
          //                         ).colorScheme.secondary,
          //                       )
          //                     : BorderSide(),
          //                 right: lang.local == 'ar'
          //                     ? BorderSide(
          //                         color: Theme.of(
          //                           context,
          //                         ).colorScheme.secondary,
          //                       )
          //                     : BorderSide(),
          //               ),
          //             ),
          //             child: Comment(
          //               width: widget.width,
          //               comment: reply,
          //               indent: widget.width * 16 / 402,
          //             ),
          //           ),
          //         )
          //         .toList(),
          //   ),
          //   crossFadeState: _showReplies
          //       ? CrossFadeState.showSecond
          //       : CrossFadeState.showFirst,
          //   duration: const Duration(milliseconds: 300),
          // ),
        ],
      ),
    );
  }
}
