import 'package:mobile_scanner/mobile_scanner.dart';

abstract class ScanQrEvent {
  ScanQrEvent();

  factory ScanQrEvent.init() = InitEvent;

  factory ScanQrEvent.detect({required BarcodeCapture barcodeCapture}) = DetectEvent;

  factory ScanQrEvent.newSession() = NewSessionEvent;

  factory ScanQrEvent.clearHistory() = ClearHistoryEvent;
}

class InitEvent extends ScanQrEvent {}

class DetectEvent extends ScanQrEvent {
  final BarcodeCapture barcodeCapture;

  DetectEvent({required this.barcodeCapture});
}

class NewSessionEvent extends ScanQrEvent {}

class ClearHistoryEvent extends ScanQrEvent {}
