import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePostTextFiled extends StatefulWidget {
  const CreatePostTextFiled({
    super.key,
    required this.width,
  });
  
  final double width;

  @override
  State<CreatePostTextFiled> createState() => _CreatePostTextFiledState();
}

class _CreatePostTextFiledState extends State<CreatePostTextFiled> {
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: TextField(
        focusNode: focusNode,
        onTapOutside: (event) {
          focusNode.unfocus();
        },
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