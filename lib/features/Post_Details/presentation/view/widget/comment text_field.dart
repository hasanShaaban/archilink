import 'dart:developer';

import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post_Details/data/models/reply_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({
    super.key,
    required this.replyTarget,
    required this.commentFocus,
    required this.onCancelReply,
  });

  final ReplyTarget replyTarget;
  final FocusNode commentFocus;
  final VoidCallback onCancelReply;

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  final TextEditingController _controller = TextEditingController();

  bool get _hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {}); // rebuild to enable/disable button
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (!_hasText) return;

    final comment = _controller.text.trim();

    log('Comment submitted: $comment');

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomInset + 10,
        left: 20,
        right: 20,
        top: 10,
      ),
      child: TextField(
        focusNode: widget.commentFocus,

        controller: _controller,

        /// allows multiline
        minLines: 1,
        maxLines: 6,

        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (widget.replyTarget.isReply) {
            widget.onCancelReply();
          }
        },

        /// after 6 lines text scrolls upward automatically
        keyboardType: TextInputType.multiline,

        style: AppTextStyle.interRegular16.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),

        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),

          suffixIcon: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _hasText ? _submitComment : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: SvgPicture.asset(
                    Assets.assetsIconsShareComment,
                    color: _hasText
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),

          hintText: widget.replyTarget.isReply
              ? 'Reply to ${widget.replyTarget.username}\'s comment'
              : 'Write a comment for ${widget.replyTarget.username}',

          hintStyle: AppTextStyle.mallannaRegular14.copyWith(
            color: AppColorsFromTheme.reverseGrayForTheme(context),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.gray),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),

          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
