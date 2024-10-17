import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IChingCoinTossScreen extends StatelessWidget {
  final String? question;

  const IChingCoinTossScreen({super.key, this.question});

  @override
  Widget build(BuildContext context) {
    final String hexagramCode = GoRouterState.of(context).pathParameters['code'] ?? '000000';
    return Scaffold(
      appBar: AppBar(
        title: Text('i_ching.coin_toss.appbar_title'.tr()),
      ),
    );
  }
}
