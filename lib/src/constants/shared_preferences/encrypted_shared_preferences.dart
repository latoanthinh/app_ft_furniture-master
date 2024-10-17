import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

export 'package:encrypt/encrypt.dart' show AESMode;

class EncryptedSharedPreferences {
  final String randomKeyKey;
  final String? randomKeyValue;
  final String randomKeyListKey;
  final AESMode mode;

  SharedPreferences? prefs;

  EncryptedSharedPreferences({
    this.prefs,
    this.mode = AESMode.sic,
    this.randomKeyValue,
    this.randomKeyKey = 'randomKey',
    this.randomKeyListKey = 'randomKeyList',
  });

  Future<SharedPreferences> getInstance() async {
    return prefs ?? await SharedPreferences.getInstance();
  }

  Encrypter _getEncrypter(SharedPreferences prefs) {
    final String? randomKey = randomKeyValue ?? prefs.getString(randomKeyKey);

    Key key;

    if (randomKey == null) {
      key = Key.fromSecureRandom(32);
      prefs.setString(randomKeyKey, key.base64);
      debugPrint('Create EncryptedSharedPreferences with key: ${key.base64}');
    } else {
      key = Key.fromBase64(randomKey);
    }

    return Encrypter(AES(key, mode: mode));
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await getInstance();

    final Encrypter encrypter = _getEncrypter(prefs);

    final IV iv = IV.fromSecureRandom(16);
    final String ivValue = iv.base64;

    final Encrypted encrypted = encrypter.encrypt(value, iv: iv);
    final String encryptedValue = encrypted.base64;

    final List<String> randomKeyList = prefs.getStringList(randomKeyListKey) ?? <String>[];
    randomKeyList.add(ivValue);
    await prefs.setStringList(randomKeyListKey, randomKeyList);

    final int index = randomKeyList.length - 1;
    await prefs.setString(encryptedValue, index.toString());

    return await prefs.setString(key, encryptedValue);
  }

  Future<String?> getString(String key) async {
    String? decrypted;

    final SharedPreferences prefs = await getInstance();

    final String? encryptedValue = prefs.getString(key);

    if (encryptedValue != null) {
      final String indexString = prefs.getString(encryptedValue)!;
      final int index = int.parse(indexString);

      final List<String> randomKeyList = prefs.getStringList(randomKeyListKey)!;
      final String ivValue = randomKeyList[index];

      final Encrypter encrypter = _getEncrypter(prefs);

      final IV iv = IV.fromBase64(ivValue);
      final Encrypted encrypted = Encrypted.fromBase64(encryptedValue);

      decrypted = encrypter.decrypt(encrypted, iv: iv);
    }

    return decrypted;
  }

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await getInstance();
    final String? encryptedValue = prefs.getString(key);
    if (encryptedValue != null) {
      await prefs.remove(key);
      final String indexString = prefs.getString(encryptedValue)!;
      final int index = int.parse(indexString);

      await prefs.remove(encryptedValue);

      final List<String> randomKeyList = prefs.getStringList(randomKeyListKey)!;
      randomKeyList.removeAt(index);
      return await prefs.setStringList(randomKeyListKey, randomKeyList);
    }

    return false;
  }

  Future<bool> clear() async {
    final prefs = await getInstance();
    return await prefs.clear();
  }

  Future<void> reload() async {
    final prefs = await getInstance();
    return await prefs.reload();
  }
}
