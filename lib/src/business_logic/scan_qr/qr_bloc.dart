import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:furniture/src/business_logic/scan_qr/qr_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/config/shared_keys.dart';
import 'qr_event.dart';

class ScanQrBloc extends Bloc<ScanQrEvent, ScanQrState> {
  final List<String?> codes = List.empty(growable: true);
  Map<String, dynamic> history = {};

  ScanQrBloc() : super(ScanQrState(codes: [], sessionTime: DateTime.now())) {
    on<InitEvent>(_init);
    on<DetectEvent>(_detect);
    on<NewSessionEvent>(_newSession);
    on<ClearHistoryEvent>(_clearHistory);
  }

  void _init(InitEvent event, Emitter<ScanQrState> emit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    history = jsonDecode(sharedPreferences.getString(SharedPreferencesKeys.qrCodeHistory) ?? '{}');
    emit(state.copyWith(history: Map.of(history)));
  }

  void _detect(DetectEvent event, Emitter<ScanQrState> emit) async {
    bool kNewCode = false;
    final List<String?> newCodes = event.barcodeCapture.barcodes.map((e) => e.rawValue).toList().cast();
    for (final newCode in newCodes) {
      if (codes.isNotEmpty && newCode != codes[0]) {
        codes.remove(newCode);
      }
      if (!codes.contains(newCode)) {
        codes.insert(0, newCode);
        kNewCode = true;
      }
    }
    if (kNewCode) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      if (history.isEmpty) {
        history = jsonDecode(sharedPreferences.getString(SharedPreferencesKeys.qrCodeHistory) ?? '{}');
      }
      history[state.sessionTime.millisecondsSinceEpoch.toString()] = List.of(codes);
      sharedPreferences.setString(SharedPreferencesKeys.qrCodeHistory, jsonEncode(history));

      emit(state.copyWith(codes: List.of(codes), history: Map.of(history)));
    }
  }

  void _newSession(NewSessionEvent event, Emitter<ScanQrState> emit) async {
    codes.clear();
    emit(state.copyWith(codes: List.of(codes), sessionTime: DateTime.now()));
  }

  void _clearHistory(ClearHistoryEvent event, Emitter<ScanQrState> emit) async {
    history.clear();
    codes.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(SharedPreferencesKeys.qrCodeHistory);
    emit(state.copyWith(codes: List.of(codes), history: Map.of(history)));
  }
}
