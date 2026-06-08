import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_chat_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_chat_state.dart';
import 'package:archilink/features/settings/presentation/views/customer_support_chat_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/customer_support_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CustomerSupportView extends StatelessWidget {
  const CustomerSupportView({super.key});

  static const String name = 'customerSupportView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(CustomerSupportChatView.name);
                        },
                        child:
                            BlocBuilder<
                              CustomerSupportChatCubit,
                              CustomerSupportChatState
                            >(
                              builder: (context, state) {
                                if (state.isLoadingChatDetails) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                if (state.chatDetailsErrorMessage != null &&
                                    state.chatDetails == null) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.chatDetailsErrorMessage!,
                                          style: AppTextStyle.interRegular14
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.refresh),
                                        onPressed: () => context
                                            .read<CustomerSupportChatCubit>()
                                            .fetchChatDetails(),
                                      ),
                                    ],
                                  );
                                }

                                final chatDetails = state.chatDetails;
                                final hasUnread =
                                    chatDetails != null &&
                                    chatDetails.unreadMessagesCount > 0;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasUnread) ...[
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            Assets.assetsIconsDot,
                                            // ignore: deprecated_member_use
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'You have a reply',
                                            style: AppTextStyle.interMedium10
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                chatDetails?.chatName ??
                                                    'Your chat',
                                                style: AppTextStyle
                                                    .interSemiBold16,
                                              ),
                                              if (chatDetails?.lastMessage !=
                                                  null) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  chatDetails!
                                                      .lastMessage!
                                                      .content,
                                                  style: AppTextStyle
                                                      .interRegular14
                                                      .copyWith(
                                                        color: Theme.of(
                                                          context,
                                                        ).disabledColor,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
                    const SizedBox(height: 12),
                    BlocBuilder<CurrentUserCubit, CurrentUserState>(
                      builder: (context, userState) {
                        return Text(
                          'Hi ${userState.username ?? 'User'},\nHow can we help you today?',
                          style: AppTextStyle.interSemiBold16.copyWith(
                            height: 1.7,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSupportInputField(
                onSend: (message) {
                  // TODO: Implement sending message to customer support
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
