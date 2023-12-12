import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_text_input.dart';
import 'package:kryptografia/pages/hamming_page/hamming_button.dart';

class HammingCode {
  // Funkcja kodująca algorytmem Hamminga (7,4)
  static String hammingEncode(String input) {
    // Zamiana tekstu na ciąg binarny
    List<int> dataBits =
        input.codeUnits.expand((char) => char.toRadixString(2).padLeft(8, '0').split('').map(int.parse)).toList();

    // Dodaj bity parzystości
    List<int> encodedData = [];
    int parity1, parity2, parity4;

    for (int i = 0; i < dataBits.length; i += 4) {
      parity1 = dataBits[i] ^ dataBits[i + 1] ^ dataBits[i + 3];
      parity2 = dataBits[i] ^ dataBits[i + 2] ^ dataBits[i + 3];
      parity4 = dataBits[i + 1] ^ dataBits[i + 2] ^ dataBits[i + 3];

      encodedData.addAll([parity1, parity2, dataBits[i], parity4, dataBits[i + 1], dataBits[i + 2], dataBits[i + 3]]);
    }

    return encodedData.join().toString();
  }

  // Funkcja uszkadzająca dane (symuluje błąd w transmisji)
  static String damageData(String data) {
    List<int> damagedData = data.split('').map((e) => int.parse(e)).toList();
    // Symulacja uszkodzenia jednego bitu
    if (damagedData.isNotEmpty) {
      int indexToDamage = Random().nextInt(damagedData.length);
      damagedData[indexToDamage] = 1 - damagedData[indexToDamage];
    }

    return damagedData.join();
  }

  static int isEvenParity(List<int> bits) {
    int onesCount = bits.fold(0, (sum, bit) => sum + bit);
    if (onesCount % 2 == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  // Funkcja dekodująca algorytmem Hamminga (7,4)
  static String hammingDecode(String damagedData) {
    List<int> receivedBits = damagedData.split('').map((e) => int.parse(e)).toList();
    List<int> decodedData = [];

    for (int i = 0; i < receivedBits.length; i += 7) {
      int p1 = receivedBits[i + 0];
      int p2 = receivedBits[i + 1];
      int p4 = receivedBits[i + 3];

      int d3 = receivedBits[i + 2];
      int d5 = receivedBits[i + 4];
      int d6 = receivedBits[i + 5];
      int d7 = receivedBits[i + 6];

      p1 = isEvenParity([p1, d3, d5, d7]);
      p2 = isEvenParity([p2, d3, d6, d7]);
      p4 = isEvenParity([p4, d5, d6, d7]);

      int errorPosition = p1 + p2 * 2 + p4 * 4;
      if (errorPosition != 0) {
        if (receivedBits[i + errorPosition -1] == 0) {
          receivedBits[i + errorPosition -1] = 1;
        } else {
          receivedBits[i + errorPosition -1] = 0;
        }
      }

      decodedData.addAll([receivedBits[i + 2], receivedBits[i + 4], receivedBits[i + 5], receivedBits[i + 6]]);
    }

    return decodedData.join();
  }

  // Funkcja zamieniająca ciąg bitów na tekst
  static String binaryToString(String binaryData) {
    List<int> asciiCodes = [];
    for (int i = 0; i < binaryData.length; i += 8) {
      int decimalValue = int.parse(binaryData.substring(i, i + 8), radix: 2);
      asciiCodes.add(decimalValue);
    }

    return String.fromCharCodes(asciiCodes);
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
      damaged = HammingCode.damageData(encoded);
    });
  }

  void decodeData() {
    setState(() {
      decoded = HammingCode.hammingDecode(damaged);
      decodedText = HammingCode.binaryToString(decoded);
    });
  }

  bool isParityBit(int index) {
    int i = index;
    int modulo = i % 7;
    if (modulo == 0 || modulo == 1 || modulo == 3) {
      return true;
    }
    return false;
  }

  // Funkcja do utworzenia kolorowego widgetu bitu
  Widget createBitWidget(String bit, bool dmg, int index, bool decoded) {
    Color textColor = Colors.white; // Domyślny kolor tekstu
    if (dmg) {
      textColor = Colors.red;
    } else {
      if (!isParityBit(index)) {
        textColor = Colors.green; // Kolor zielony dla bitów informacyjnych
      } else {
        textColor = Colors.blue; // Kolor niebieski dla bitów parzystości
      }
    }
    if (decoded) {
      textColor = Colors.green;
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
                            child: createBitWidget(encoded[i], false, i, false)),
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
                                return createBitWidget(damaged[i], false, i, false);
                              } else {
                                return createBitWidget(damaged[i], true, i, false);
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
                            child: createBitWidget(decoded[i], false, i, true)),
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
