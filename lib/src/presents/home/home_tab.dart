import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/data.dart';
import '../../constants/router.dart';
import '../../constants/size.dart';
import '../widgets/app_image.dart';
import '../widgets/app_logo.dart';

class _AppInfo {
  final String imageAsset;
  final String appName;
  final String path;

  const _AppInfo({
    required this.imageAsset,
    required this.appName,
    required this.path,
  });
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final List<_AppInfo> _appInfos = const [
    _AppInfo(
      imageAsset: 'assets/images/i-ching/i-ching.png',
      appName: 'index.apps.i_ching',
      path: AppRouter.iChingIndex,
    ),
  ];

  void _onPressedApp(BuildContext context, _AppInfo appInfo) {
    context.goNamed(appInfo.path);
  }

  @override
  Widget build(BuildContext context) {
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: AppSize.sp192,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: SizedBox(
                height: AppSize.sp64,
                child: Padding(
                  padding: EdgeInsets.all(AppSize.sp8),
                  child: AppBranch.logo(),
                ),
              ),
              background: AppImage(
                '${AppData.domainWeb}/web/assets/images/anhh.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sizeMargin).copyWith(top: sizeMargin),
            sliver: SliverToBoxAdapter(
              child: Text(
                'home.title_application'.tr(),
                style: textStyle.headlineMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(sizeMargin),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 3 / 4.5,
                maxCrossAxisExtent: AppSize.sp128,
                crossAxisSpacing: sizeMargin,
                mainAxisSpacing: sizeMargin,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: _appInfos.length,
                (context, index) {
                  final appInfo = _appInfos[index];
                  return InkWell(
                    onTap: () => _onPressedApp(context, appInfo),
                    borderRadius: BorderRadius.circular(AppSize.sp8),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSize.sp8),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSize.sp8),
                              child: Image.asset(
                                appInfo.imageAsset,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSize.sp4),
                          Text(
                            appInfo.appName,
                            maxLines: 2,
                            style: textStyle.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sizeMargin).copyWith(top: sizeMargin),
            sliver: SliverToBoxAdapter(
              child: Text(
                'home.title_today_activity'.tr(),
                style: textStyle.headlineMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(sizeMargin),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 1,
                maxCrossAxisExtent: AppSize.sp128,
                crossAxisSpacing: sizeMargin,
                mainAxisSpacing: sizeMargin,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: 2,
                (context, index) {
                  return Container(
                    color: Colors.blue,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
