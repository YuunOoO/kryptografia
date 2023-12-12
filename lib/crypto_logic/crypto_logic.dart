import 'dart:convert';

import 'package:flutter_des/flutter_des.dart';
import 'package:simple_rc4/simple_rc4.dart';

class CryptoLogic {
  List<String> rowsSaved = [];
  String caesarEncryptDecrypt(String text, int key, bool encrypt) {
    String result = '';
    int shift = encrypt ? key : -key;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char.contains(RegExp(r'[a-zA-Z]'))) {
        String shiftedChar = String.fromCharCode(
            (char.codeUnitAt(0) + shift - (char == char.toUpperCase() ? 65 : 97)) % 26 +
                (char == char.toUpperCase() ? 65 : 97));
        result += shiftedChar;
      } else {
        result += char;
      }
    }

    return result;
  }

  String polyalphabeticEncryptDecrypt(String text, String key, bool encrypt) {
    String result = '';
    int textLength = text.length;
    int keyLength = key.length;

    for (int i = 0; i < textLength; i++) {
      int x = i % keyLength;

      if (i % 2 == 0) {
        // Oblicz przesunięcie zgodnie z kluczem
        int shift = key.codeUnitAt(x) - 'a'.codeUnitAt(0);
        result += String.fromCharCode(encrypt ? text.codeUnitAt(i) + shift : text.codeUnitAt(i) - shift);
      } else {
        // Oblicz przesunięcie zgodnie z kluczem
        int shift = key.codeUnitAt(x) - 'a'.codeUnitAt(0);
        result += String.fromCharCode(encrypt ? text.codeUnitAt(i) + shift : text.codeUnitAt(i) - shift);
      }
    }

    return result;
  }

  String transpositionEncrypt(String text, int key) {
    List<String> rows = List.generate(key, (index) => "");

    for (int i = 0; i < text.length; i++) {
      int row = i % key;
      rows[row] += text[i];
    }
    rowsSaved = rows;

    return rows.join(" ");
  }

  String transpositionDecrypt(String text, int key) {
    String result = "";

    int i = 0;
    int k = 0;
    while (i < rowsSaved.join().length) {
      for (int p = 0; p < key; p++) {
        int row = i % key;
        result += rowsSaved[row][k];
        i++;
        if (i >= rowsSaved.join().length) {
          return result;
        }
      }
      k++;
    }
    return result;
  }

  String customBase64Encode(String input) {
    final List<int> bytes = input.codeUnits; // Konwertuj wejściowy ciąg na listę kodów znaków ASCII
    final StringBuffer result = StringBuffer(); // Inicjalizuj bufor wynikowy
    int padding = 0; // Inicjalizuj zmienną do śledzenia ilości znaków padding

    for (int i = 0; i < bytes.length; i += 3) {
      // Iteruj przez listę bajtów w grupach po 3
      final int value = ((bytes[i] & 0xFF) << 16) | // Tworzenie 24-bitowej wartości z trzech bajtów
          ((i + 1 < bytes.length ? bytes[i + 1] & 0xFF : 0) <<
              8) | // sprawdza, czy istnieje co najmniej jeden kolejny bajt po obecnym w tablicy bajtów bytes.
          ((i + 2 < bytes.length ? bytes[i + 2] & 0xFF : 0));

      for (int j = 0; j < 4; j++) {
        // Iteruj po 4 znaki Base64
        if (i + j <= bytes.length) {
          final int index = (value >> (18 - j * 6)) & 0x3F; // Wybierz indeks znaku w alfabecie Base64
          result.write(
              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'[index]); // Dodaj znak Base64 do wyniku
        } else {
          result.write('='); // Dodaj znak padding '=' i zwiększ licznik paddingu
          padding++;
        }
      }
    }

    return result
        .toString()
        .substring(0, result.length - padding); // Zwróć wynik jako ciąg Base64 z usuniętym paddingiem
  }

  String customBase64Decode(String input) {
    const String base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    const padding = '=';

    final result = StringBuffer();
    var value = 0;
    var bits = 0;

    for (final char in input.runes) {
      if (char == padding.runes.first) {
        break; // Zakończ dekodowanie po napotkaniu znaku padding
      }

      // Znajdowanie pozycji (indeksu) znaku w ciągu znaków Base64
      final charValue = base64Chars.indexOf(String.fromCharCode(char));
      if (charValue >= 0) {
        // Dodaj 6 bitów wartości znaku do obecnego value
        value = (value << 6) | charValue;
        bits += 6;

        if (bits >= 8) {
          // Jeśli mamy wystarczającą ilość bitów, dodaj bajt do wyniku
          result.writeCharCode((value >> (bits - 8)) & 0xFF);
          bits -= 8; // Aktualizacja ilości pozostałych bitów
        }
      }
    }

    return result.toString();
  }

  String rc4Encode(String input, String key) {
    var rc4 = RC4(key);
    var encodeString = rc4.encodeString(input);
    print(encodeString);
    return encodeString;
  }

  String rc4Decode(String input, String key) {
    var rc4 = RC4(key);
    var decodeString = rc4.decodeString(input);
    print(decodeString);
    return decodeString;
  }

  Future<String> desEncode(String input, String key) async {
    const iv = "12345678";

    var encrypt = await FlutterDes.encryptToBase64(input, key, iv: iv);
    print(encrypt);
    return encrypt;
  }

  Future<String> desDecode(String input, String key) async {
    const iv = "12345678";
    var encrypt = await FlutterDes.decryptFromBase64(input, key, iv: iv);
    print(encrypt);
    return encrypt!;
  }
}
