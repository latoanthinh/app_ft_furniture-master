import 'package:flutter/material.dart';

import '../../constants/size.dart';

abstract class AppBranch extends StatelessWidget {
  const AppBranch({super.key});

  const factory AppBranch.icon() = _Icon;

  const factory AppBranch.logo() = _Logo;
}

class _Logo extends AppBranch {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.sp8),
      child: Visibility(
        visible: mediaQueryData.platformBrightness == Brightness.light,
        replacement: Image.asset('assets/images/logo-dark.png'),
        child: Image.asset('assets/images/logo-light.png'),
      ),
    );
  }
}

class _Icon extends AppBranch {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.sp8),
      child: Visibility(
        visible: mediaQueryData.platformBrightness == Brightness.light,
        replacement: Image.asset('assets/images/app-icon-dark.png'),
        child: Image.asset('assets/images/app-icon-light.png'),
      ),
    );
  }
}
