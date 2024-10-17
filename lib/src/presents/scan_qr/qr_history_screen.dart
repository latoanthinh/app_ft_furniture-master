import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../business_logic/scan_qr/qr_bloc.dart';
import '../../business_logic/scan_qr/qr_event.dart';
import '../../business_logic/scan_qr/qr_state.dart';
import '../../constants/size.dart';

class ScanQrHistoryScreen extends StatelessWidget {
  const ScanQrHistoryScreen({super.key});

  Future<void> _onPressedClearHistory(BuildContext context) async {
    final ScanQrBloc scanQrBloc = context.read();
    final colorScheme = Theme.of(context).colorScheme;
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('scan_qr_history.clear_confirm_title'.tr()),
          content: Text('scan_qr_history.clear_confirm_body'.tr()),
          actions: [
            ElevatedButton(
              onPressed: context.pop,
              child: Text('scan_qr_history.clear_cancel_button'.tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () async {
                scanQrBloc.add(ScanQrEvent.clearHistory());
                context.pop();
              },
              child: Text('scan_qr_history.clear_confirm_button'.tr()),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _refresh(BuildContext context) async {
    final ScanQrBloc scanQrBloc = context.read();
    scanQrBloc.add(ScanQrEvent.init());
    await scanQrBloc.stream.first;
  }

  Future<void> _onPressedOpenUrl(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('scan_qr.toast_cant_open_url'.tr(namedArgs: {'url': url})),
          action: SnackBarAction(
            label: 'scan_qr.toast_force_launch_url'.tr(),
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            },
          ),
        ));
      }
    }
  }

  Future<void> _onPressedCopyCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('scan_qr.toast_copy_success'.tr(namedArgs: {'content': code})),
        action: SnackBarAction(
          label: 'scan_qr.toast_copy_button'.tr(),
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('scan_qr_history.appbar_title'.tr()),
        actions: [
          IconButton(
            onPressed: () => _onPressedClearHistory(context),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          children: [
            BlocSelector<ScanQrBloc, ScanQrState, Map<String, dynamic>?>(
              selector: (state) => state.history,
              builder: (context, histories) {
                return Visibility(
                  visible: (histories?.length ?? 0) > 0,
                  replacement: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(sizeMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: sizeScreen.height / 3),
                        Icon(
                          Icons.error_outline,
                          size: textTheme.displaySmall?.fontSize,
                        ),
                        Text(
                          'scan_qr_history.empty'.tr(),
                          style: textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(sizeMargin),
                    itemCount: histories?.length ?? 0,
                    separatorBuilder: (context, index) => SizedBox(height: sizeMargin),
                    itemBuilder: (context, index) {
                      final sessionKey = histories!.keys.elementAt(histories.length - 1 - index);
                      final sessionValue = List.of(histories[sessionKey]);
                      final time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(sessionKey) ?? 0);
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(sizeMargin),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Text(
                                '${DateFormat.Hms().format(time)} | ${DateFormat.yMMMd().format(time)}',
                                style: textTheme.titleLarge,
                              ),
                              const Divider(),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sessionValue.length,
                                separatorBuilder: (context, index) => const SizedBox(height: AppSize.sp4),
                                itemBuilder: (context, index) {
                                  final code = sessionValue[index] as String;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(AppSize.sp4),
                                        child: InkWell(
                                          onTap: () => _onPressedOpenUrl(context, code),
                                          child: Padding(
                                            padding: const EdgeInsets.all(AppSize.sp4),
                                            child: Icon(Icons.open_in_new, color: colorScheme.primary),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSize.sp4),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(AppSize.sp4),
                                            child: InkWell(
                                              onTap: () => _onPressedCopyCode(context, code),
                                              child: Padding(
                                                padding: const EdgeInsets.all(AppSize.sp6),
                                                child: Text(code, style: TextStyle(color: colorScheme.primary)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
