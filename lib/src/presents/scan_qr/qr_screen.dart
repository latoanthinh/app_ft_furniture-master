import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../business_logic/scan_qr/qr_bloc.dart';
import '../../business_logic/scan_qr/qr_event.dart';
import '../../business_logic/scan_qr/qr_state.dart';
import '../../constants/data.dart';
import '../../constants/router.dart';
import '../../constants/size.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with WidgetsBindingObserver {
  CameraFacing currentCameraFacing = CameraFacing.back;
  MobileScannerController? scanController;

  Future<void> reStartCamera() async {
    final sizeScreen = MediaQuery.sizeOf(context);
    await scanController?.dispose();
    scanController = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.normal,
      facing: currentCameraFacing,
      formats: [BarcodeFormat.all],
      cameraResolution: sizeScreen,
    );
    await scanController!.start();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> disposeCamera() async {
    await scanController?.dispose();
    scanController = null;
    setState(() {});
  }

  void _handleBarcodeDetect(BarcodeCapture event) {
    final ScanQrBloc scanQrDetectBloc = context.read();
    scanQrDetectBloc.add(ScanQrEvent.detect(barcodeCapture: event));
  }

  Future<void> _onPressRefreshAction() async {
    final ScanQrBloc scanQrDetectBloc = context.read();
    scanQrDetectBloc.add(ScanQrEvent.newSession());
  }

  Future<void> _onPressScanImage() async {
    final file = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if (file != null) {
      final barcodeCapture = await scanController?.analyzeImage(file.paths.single ?? '');
      if (barcodeCapture != null) {
        _handleBarcodeDetect(barcodeCapture);
      }
      final List<String>? newCodes =
          barcodeCapture?.barcodes.map((e) => e.rawValue ?? 'qr_code.empty_result'.tr()).toList().cast();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('qr_code.scan_image.success_title'.tr()),
            content: (newCodes ?? []).isEmpty
                ? Text('qr_code.scan_image.not_found'.tr())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: newCodes!.map((e) => Text(e)).toList(growable: true),
                  ),
            actions: [
              ElevatedButton(
                onPressed: context.pop,
                child: Text('qr_code.scan_image.close_button'.tr()),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _onPressChangeCamera() async {
    await scanController?.switchCamera();
    currentCameraFacing = scanController?.facing ?? currentCameraFacing;
    setState(() {});
  }

  Future<void> _onPressTorch() async {
    await scanController?.toggleTorch();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      const webScript = '${AppData.domainWeb}/web/assets/library/qr_scan_index.min.js';
      MobileScannerPlatform.instance.setBarcodeLibraryScriptUrl(webScript);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await reStartCamera();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!(scanController?.value.isInitialized ?? false)) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(scanController?.start());
        break;
      case AppLifecycleState.inactive:
        unawaited(scanController?.stop());
        break;
      // case AppLifecycleState.detached:
      // case AppLifecycleState.hidden:
      // case AppLifecycleState.paused:
      default:
        break;
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await scanController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }

  Widget _buildView(BuildContext context) {
    final sizeScreen = MediaQuery.sizeOf(context);
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: context.pop),
        title: Text('scan_qr.appbar_title'.tr()),
        actions: [
          IconButton(
            onPressed: _onPressOpenHistory,
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: _onPressRefreshAction,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.center,
        spacing: sizeMargin,
        runSpacing: AppSize.sp16,
        children: [
          Visibility(
            visible: !kIsWeb,
            child: FloatingActionButton(
              onPressed: () => _onPressScanImage(),
              child: const Icon(Icons.image_search),
            ),
          ),
          FloatingActionButton.small(
            heroTag: 'change camera',
            onPressed: _onPressChangeCamera,
            child: Visibility(
              visible: currentCameraFacing == CameraFacing.back,
              replacement: const Icon(Icons.switch_camera),
              child: const Icon(Icons.switch_camera_outlined),
            ),
          ),
          FloatingActionButton.small(
            heroTag: 'change lightbulb',
            onPressed: _onPressTorch,
            child: Visibility(
              visible: scanController?.torchEnabled ?? false,
              replacement: const Icon(Icons.lightbulb_outline),
              child: const Icon(Icons.lightbulb),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: scanController,
            fit: BoxFit.cover,
            placeholderBuilder: (context, child) => const Center(child: CircularProgressIndicator()),
            onDetect: (barcodes) => _handleBarcodeDetect(barcodes),
            errorBuilder: (context, error, child) => _ScannerErrorSession(error: error),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: BlocSelector<ScanQrBloc, ScanQrState, DateTime>(
              selector: (state) => state.sessionTime,
              builder: (context, sessionTime) {
                return Text(
                  '${DateFormat.Hms().format(sessionTime)} | '
                  '${DateFormat.yMMMMEEEEd().format(sessionTime)}',
                  style: textTheme.labelSmall,
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: sizeScreen.height / 2,
            child: _ScannerResultSession(),
          ),
        ],
      ),
    );
  }

  Future<void> _onPressOpenHistory() async {
    await disposeCamera();
    if (mounted) {
      await context.pushNamed(AppRouter.scanQrHistory);
    }
    await reStartCamera();
  }
}

class _ScannerResultSession extends StatelessWidget {
  Future<void> _onPressedOpenUrl(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
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
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final colorScheme = Theme.of(context).colorScheme;
    return BlocSelector<ScanQrBloc, ScanQrState, List<String?>>(
      selector: (state) => state.codes,
      builder: (context, codes) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: codes.map((codeState) {
              final code = codeState ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSize.sp8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.sp4),
                      elevation: AppSize.sp4,
                      child: InkWell(
                        onTap: () => _onPressedOpenUrl(context, code),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.sp4),
                          child: Icon(Icons.open_in_new, color: colorScheme.onPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.sp4),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(AppSize.sp4),
                          elevation: AppSize.sp4,
                          child: InkWell(
                            onTap: () => _onPressedCopyCode(context, code),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSize.sp6),
                              child: Text(code, style: TextStyle(color: colorScheme.onPrimary)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ScannerErrorSession extends StatelessWidget {
  const _ScannerErrorSession({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final sizeMargin = AppSize.sizeScreenMargin(context);
    final textTheme = Theme.of(context).textTheme;

    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'qr_scanner.error.controller_uninitialized'.tr();
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'qr_scanner.error.permission_denied'.tr();
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'qr_scanner.error.device_unsupported'.tr();
      default:
        errorMessage = 'qr_scanner.error.unknown'.tr();
        break;
    }

    return Padding(
      padding: EdgeInsets.all(sizeMargin),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: textTheme.displaySmall?.fontSize,
            ),
            Text(
              errorMessage,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSize.sp8),
            Text(
              '${error.errorDetails?.message} (${error.errorCode.name})',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
