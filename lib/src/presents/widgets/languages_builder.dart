import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageBuilder extends StatelessWidget {
  final Widget child;

  const LanguageBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      saveLocale: true,
      useOnlyLangCode: true,
      useFallbackTranslations: true,
      supportedLocales: const [Locale('en'), Locale('vi')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      assetLoader: _LanguageLoader(),
      child: child,
    );
  }
}

class _LanguageLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final langData = await rootBundle.loadString('$path/${locale.languageCode}.json', cache: !kDebugMode);
    final langJson = jsonDecode(langData);
    return langJson;
  }
}
