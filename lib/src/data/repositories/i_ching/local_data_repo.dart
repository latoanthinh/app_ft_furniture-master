import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/hexagram.dart';

class IChingLocalDataRepo {
  Map<String, Hexagram>? _cacheHexagrams;

  IChingLocalDataRepo();

  Future<Map<String, Hexagram>> getHexagrams() async {
    final jsonString = await rootBundle.loadString('assets/data/i-ching/i-ching.json');
    final json = List.of(jsonDecode(jsonString));
    final result = <String, Hexagram>{};
    for (final e in json) {
      final hexagram = Hexagram.fromMap(e);
      result[hexagram.code.toString()] = hexagram;
    }
    _cacheHexagrams = result;
    return _cacheHexagrams!;
  }

  Future<Hexagram?> getHexagram({String? code}) async {
    if (_cacheHexagrams == null) {
      await getHexagrams();
    }
    return _cacheHexagrams?[code];
  }

  Future<String> getHexagramMd({required String hexagramCode}) async {
    final result = await rootBundle.loadString('assets/data/i-ching/vi/64-i-ching/$hexagramCode.md');
    return result;
  }
}
