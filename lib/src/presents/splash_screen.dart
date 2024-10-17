import 'dart:math';
import 'package:flutter/material.dart';
import 'package:furniture/src/presents/widgets/app_logo.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: min(screenSize.width, screenSize.height) / 2,
            height: min(screenSize.width, screenSize.height) / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: const AppBranch.icon(),
            ),
          ),
          CircularProgressIndicator(color: colorScheme.onPrimary),
        ],
      ),
    );
  }
}
