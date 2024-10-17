import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/splash/bloc.dart';
import '../../business_logic/splash/state.dart';
import '../splash_screen.dart';

class SplashBuilder extends StatelessWidget {
  final Widget child;

  const SplashBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) => Visibility(
        visible: state.isSuccess,
        replacement: const SplashScreen(),
        child: child,
      ),
    );
  }
}
