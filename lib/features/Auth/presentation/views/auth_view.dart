
import 'package:archilink/features/Auth/presentation/manager/controller/auth_flow_controller.dart';

import 'package:archilink/features/Auth/presentation/views/widgets/auth_view_body.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const String name = '/auth';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFlowController(),
      child: const AuthViewBody(),
    );
  }
}

