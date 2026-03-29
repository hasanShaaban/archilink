import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostTextFiled extends StatelessWidget {
  const CreatePostTextFiled({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20 + width * 34 / 402 + 8,
        right: 20,
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: 1,
        maxLines: null,
        onChanged: (text) =>
            context.read<CreatePostCubit>().onTextChanged(text),
        decoration: const InputDecoration.collapsed(
          hintText: "What's on your mind?",
        ),
        style: AppTextStyle.interRegular16,
      ),
    );
  }
}