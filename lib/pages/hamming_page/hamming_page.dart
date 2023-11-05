import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_text_input.dart';
import 'package:kryptografia/pages/hamming_page/hamming_button.dart';

class HammingCode {
  // Funkcja kodująca ciąg bitów za pomocą kodu Hamminga (7,4)
  static bool isPowerOfTwo(int x) {
    return (x & (x - 1)) == 0;
  }

  static String hammingEncode(String input) {
    // Inicjalizacja zakodowanego ciągu
    String encoded = '';

    // Zamień string na ciąg bitów
    String base64input = base64Encode(utf8.encode(input));
    print(base64input);
    List<int> bytes = base64.decode(base64input);
    String binaryString = bytes.map((byte) {
      String binaryByte = byte.toRadixString(2);
      return '0' * (8 - binaryByte.length) + binaryByte;
    }).join('');
    print(binaryString);

    int dataLength = binaryString.length;
    int encodedLength = (dataLength ~/ 4) * 7 + (dataLength % 4) + 7; // Oblicz długość zakodowanego ciągu.

    List<int> encodedData = List<int>.generate(encodedLength, (index) => 0);

    int dataIndex = 0;
    int encodedIndex = 0;

    while (dataIndex < dataLength) {
      for (int i = 0; i < 7; i++) {
        if (isPowerOfTwo(i + 1)) {
          // To jest bit parzystości, pozostawiamy go na razie zerem.
          encodedIndex++;
        } else {
          encodedData[encodedIndex] = int.parse(binaryString[dataIndex]);
          encodedIndex++;
          dataIndex++;
        }
      }
    }

    // Oblicz bity parzystości.
    for (int i = 0; i < 3; i++) {
      int parityBitPosition = 1 << i;
      for (int j = parityBitPosition - 1; j < encodedLength; j += 1 << (i + 1)) {
        for (int k = 0; k < parityBitPosition && j + k < encodedLength; k++) {
          encodedData[parityBitPosition - 1] ^= encodedData[j + k];
        }
      }
    }

    String encodedBinaryString = encodedData.join();

    return encodedBinaryString;
  }

  static String binaryToBase64(String binary) {
    List<int> bytes = List.generate(binary.length ~/ 8, (i) {
      return int.parse(binary.substring(i * 8, (i + 1) * 8), radix: 2);
    });

    String base64String = base64.encode(Uint8List.fromList(bytes));
    return base64String;
  }

  static String hammingDecode(String encodedData) {
    int encodedLength = encodedData.length;
    int dataLength = (encodedLength ~/ 7) * 4; // Oblicz długość danych.

    List<int> decodedData = List<int>.generate(dataLength, (index) => 0);
    List<int> errorPositions = [];

    int dataIndex = 0;
    int encodedIndex = 0;

    while (dataIndex < dataLength) {
      int parityBits = 0; // Bit parzystości, który będzie używany do sprawdzania błędów.
      List<int> parityBitsValues = [];

      for (int i = 0; i < 7; i++) {
        if (isPowerOfTwo(i + 1)) {
          parityBits ^= int.parse(encodedData[encodedIndex]);
          parityBitsValues.add(int.parse(encodedData[encodedIndex]));
          encodedIndex++;
        } else {
          decodedData[dataIndex] = int.parse(encodedData[encodedIndex]);
          encodedIndex++;
          dataIndex++;
        }
      }

      if (parityBits != 0) {
        // Jeśli bit parzystości nie jest zerem, oznacza to błąd.
        int errorPosition = 0;
        for (int i = 0; i < parityBitsValues.length; i++) {
          errorPosition += parityBitsValues[i] * (1 << i);
        }
        errorPositions.add(errorPosition);
      }
    }

    // Próbuj naprawić pojedynczy błąd w danych
    for (int errorPosition in errorPositions) {
      int correctedBit = int.parse(encodedData[errorPosition - 1]) == 0 ? 1 : 0;
      decodedData[errorPosition - 1] = correctedBit;
    }

    // Usuń nadmiarowe zera na końcu odkodowanego ciągu.
    int trimmedDataLength = dataLength;
    while (trimmedDataLength > 0 && decodedData[trimmedDataLength - 1] == 0) {
      trimmedDataLength--;
    }

    String decodedBinaryString = decodedData.sublist(0, trimmedDataLength).join();
    print(decodedBinaryString);
    return decodedBinaryString;
  }

  static String stringToBinary(String input) {
    StringBuffer binaryString = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      String binaryChar = input.codeUnitAt(i).toRadixString(2);
      binaryString.write('0' * (8 - binaryChar.length) + binaryChar);
    }

    return binaryString.toString();
  }

  static String binaryToString(String binary) {
    String text = '';
    for (int i = 0; i < binary.length; i += 8) {
      String binaryChar = binary.substring(i, i + 8);
      int charCode = int.parse(binaryChar, radix: 2);
      text += String.fromCharCode(charCode);
      print(text);
    }
    return text;
  }
}

class HammingCodeScreen extends StatefulWidget {
  const HammingCodeScreen({super.key});

  @override
  HammingCodeScreenState createState() => HammingCodeScreenState();
}

class HammingCodeScreenState extends State<HammingCodeScreen> {
  TextEditingController textEditingController = TextEditingController();
  String input = '';
  String encoded = '';
  String damaged = '';
  String decoded = '';
  String decodedText = '';

  @override
  void initState() {
    textEditingController.addListener(() {
      setState(() {
        input = textEditingController.text;
        encoded = '';
        damaged = '';
        decoded = '';
        decodedText = '';
      });
    });
    super.initState();
  }

  void encodeData() {
    setState(() {
      encoded = HammingCode.hammingEncode(input);
    });
  }

  void damageData() {
    setState(() {
      // Uszkadzanie danych - zamieniamy losowy bit
      var random = Random();
      int index = random.nextInt(encoded.length);
      damaged = encoded.substring(0, index) + (encoded[index] == '0' ? '1' : '0') + encoded.substring(index + 1);
    });
  }

  void decodeData() {
    setState(() {
      decoded = HammingCode.hammingDecode(damaged);
      decodedText = HammingCode.binaryToString(decoded);
    });
  }

  // Funkcja do utworzenia kolorowego widgetu bitu
  Widget createBitWidget(String bit, bool dmg) {
    Color textColor = Colors.black; // Domyślny kolor tekstu
    if (dmg) {
      textColor = Colors.red;
    } else {
      if (bit == '1') {
        textColor = Colors.green; // Kolor zielony dla bitów informacyjnych
      } else if (bit == '0') {
        textColor = Colors.blue; // Kolor niebieski dla bitów parzystości
      }
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: textColor, // Tło z kolorowym zaznaczeniem
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        bit,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CryptoTextInput(controller: textEditingController, label: "wprowadz tekst"),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    encodeData();
                  },
                  child: const HammginButton(buttonText: "Zakoduj dane"),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < encoded.length; i++)
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: createBitWidget(encoded[i], false)),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    damageData();
                  },
                  child: const HammginButton(buttonText: "Uszkodź dane"),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < damaged.length; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (encoded[i] == damaged[i]) {
                                return createBitWidget(damaged[i], false);
                              } else {
                                return createBitWidget(damaged[i], true);
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    decodeData();
                  },
                  child: const HammginButton(buttonText: "Dekoduj dane"),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < decoded.length; i++)
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: createBitWidget(decoded[i], false)),
                    ],
                  ),
                ),
                Text(
                  'Czyli:  $decodedText',
                  style: const TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
