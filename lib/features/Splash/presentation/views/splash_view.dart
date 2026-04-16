import 'dart:ui';

import 'package:archilink/core/network/websocket/pusher_client.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/auth_cubit.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:archilink/features/Main/presentation/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const String name = 'SplashView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: SplashViewBody()));
  }
}

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  double opacity = 0;

  @override
  void initState() {
    context.read<AuthCubit>().initApp();
    Future.delayed(const Duration(microseconds: 300), () {
      setState(() {
        opacity = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 2300), () {
      _navigation();
    });

    super.initState();
  }

  void _navigation() {
    final AuthRepo repo = sl<AuthRepo>();
    final bool? rememberMe = repo.getRemeberMe();
    final token = context.read<CurrentUserCubit>().state.token;

    if (token != null) {
      // Fire and forget — PusherClient._initialized guard prevents double init
      sl<PusherClient>().init(token: token);
    }

    if (rememberMe != null && rememberMe) {
      Navigator.pushReplacementNamed(context, MainView.name);
    } else {
      Navigator.pushReplacementNamed(context, AuthView.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double viewportWidth = MediaQuery.of(context).size.width;
    final double viewportHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: -30,
          child: SizedBox(
            width: viewportWidth,
            height: viewportHeight,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Image.asset(
                Assets.assetsImagesBackgroundLight,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInCubic,
          opacity: opacity,
          child: Center(child: SvgPicture.asset(Assets.assetsIconsAppLogo)),
        ),
      ],
    );
  }
}
