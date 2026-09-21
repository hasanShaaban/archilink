import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<CreatePostCubit>().state.postText,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listenWhen: (previous, current) =>
          previous.postText != current.postText &&
          current.postText != _controller.text,
      listener: (context, state) {
        _controller.value = _controller.value.copyWith(
          text: state.postText,
          selection: TextSelection.collapsed(offset: state.postText.length),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: TextField(
          controller: _controller,
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
      ),
    );
  }
}