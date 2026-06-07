import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/settings/presentation/views/widgets/customer_support_input_field.dart';
import 'package:flutter/material.dart';
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
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.assetsIconsDot,
                              // ignore: deprecated_member_use
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'You have a reply',
                              style: AppTextStyle.interMedium10.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your chat',
                              style: AppTextStyle.interSemiBold16,
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
                    const SizedBox(height: 12),
                    Text(
                      'Hi Username,\n How can we help you today?',
                      style: AppTextStyle.interSemiBold16.copyWith(height: 1.7),
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
