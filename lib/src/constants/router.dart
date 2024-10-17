import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../business_logic/i_ching/i_ching_list/list_bloc.dart';
import '../business_logic/i_ching/i_ching_list/list_event.dart';
import '../business_logic/scan_qr/qr_bloc.dart';
import '../business_logic/scan_qr/qr_event.dart';
import '../data/repositories/i_ching/local_data_repo.dart';
import '../presents/error_404.dart';
import '../presents/i_ching/coin_toss_screen.dart';
import '../presents/i_ching/detail_screen.dart';
import '../presents/i_ching/index_screen.dart';
import '../presents/index_screen.dart';
import '../presents/scan_qr/qr_history_screen.dart';
import '../presents/scan_qr/qr_screen.dart';

abstract final class AppRouter {
  static const String index = '/';
  static const String error404 = '/error-404';
  static const String scanQr = 'scan-qr';
  static const String scanQrHistory = 'scan-qr-history';
  static const String iChingIndex = 'i-ching';
  static const String iChingDetail = 'i-ching-detail/code/:code';
  static const String iChingCoinToss = 'i-ching-coin-toss';

  static final GoRouter goRouter = GoRouter(
    observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    errorBuilder: (context, state) {
      final er = state.error?.message ?? 'Unknown Error!';
      // ignore: avoid_print
      print(
        'PATH: ${state.uri}'
        '\n'
        'ERROR: $er',
      );
      return const Error404();
    },
    routes: [
      GoRoute(
        path: index,
        name: index,
        builder: (context, state) => const IndexScreen(),
        routes: [
          ShellRoute(
            observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
            builder: (context, state, child) => BlocProvider(
              create: (context) => ScanQrBloc()..add(ScanQrEvent.init()),
              child: Builder(builder: (context) => child),
            ),
            routes: [
              GoRoute(
                path: scanQr,
                name: scanQr,
                builder: (context, state) => const ScanQrScreen(),
                routes: [
                  GoRoute(
                    path: scanQrHistory,
                    name: scanQrHistory,
                    builder: (context, state) => const ScanQrHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
          ShellRoute(
            observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
            builder: (context, state, child) {
              final iChingLocalDataRepo = IChingLocalDataRepo();
              return MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(create: (context) => iChingLocalDataRepo),
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => IChingListBloc(localDataRepo: iChingLocalDataRepo)
                        ..add(
                          IChingListEvent.init(),
                        ),
                    ),
                  ],
                  child: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: iChingIndex,
                name: iChingIndex,
                builder: (context, state) => const IChingIndexScreen(),
                routes: [
                  GoRoute(
                    path: iChingDetail,
                    name: iChingDetail,
                    builder: (context, state) => IChingDetailScreen(
                      hexagramCode: state.pathParameters['code'] ?? '000000',
                    ),
                  ),
                  GoRoute(
                    path: iChingCoinToss,
                    name: iChingCoinToss,
                    builder: (context, state) => IChingCoinTossScreen(
                      question: state.pathParameters['question'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: error404,
        name: error404,
        builder: (context, state) => const Error404(),
      ),
    ],
  );
}
