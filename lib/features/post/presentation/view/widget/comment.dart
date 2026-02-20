import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/presentation/view/widget/comment_like_button.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.width,
    required this.comment,
    this.indent = 0,
  });

  final double width;
  final Map comment;
  final double indent;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool _showReplies = false;

  @override
  Widget build(BuildContext context) {
    List replies = widget.comment['replies'];
    var lang = S.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8,
      left: lang.local == 'en' ? widget.indent : 0,
      right: lang.local == 'ar' ? widget.indent : 0
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
                    Assets.assetsIconsUser, //---------------image
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 24,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.comment['user'],
                          style: AppTextStyle.interMedium14.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          ' ${widget.comment['time']}',
                          style: AppTextStyle.interMedium14.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Spacer(),
                        CommentLikeButton(),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.comment['comment'],
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
          replies.isNotEmpty
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
                        _showReplies ? 'Hide Replies' : 'Show Replies',
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
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: replies.map((reply) => Container(
                decoration: BoxDecoration(
                  border: Border(left: lang.local == 'en' ? BorderSide(color: Theme.of(context).colorScheme.secondary): BorderSide(),
                  right: lang.local == 'ar' ? BorderSide(color: Theme.of(context).colorScheme.secondary): BorderSide())
                ),
                child: Comment(width: widget.width, comment: reply, indent: widget.width * 16/402,))).toList(),
            ),
            crossFadeState: _showReplies
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
