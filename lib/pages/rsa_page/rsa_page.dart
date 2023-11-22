import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_text_input.dart';
import 'package:kryptografia/pages/hamming_page/hamming_button.dart';

class RsaPage extends StatefulWidget {
  const RsaPage({Key? key}) : super(key: key);

  @override
  RsaPageState createState() => RsaPageState();
}

class RsaPageState extends State<RsaPage> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController pController = TextEditingController();
  TextEditingController qController = TextEditingController();
  String input = '';
  String logs = 'Logi:';
  late List<int> publicKey;
  late List<int> privateKey;
  int tocjent = 0;
  int iloczynPQ = 0;
  List<int>? encryptedMessage;
  String decryptedMessageValue = "";
  bool encrypt = true;
  bool decrypt = false;

  @override
  void initState() {
    textEditingController.addListener(() {
      setState(() {
        input = textEditingController.text;
      });
    });
    super.initState();
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(seconds: 3),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Szyfrowanie RSA",
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 60, 143, 63),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier New',
                          ),
                          speed: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                ),
                CryptoTextInput(controller: qController, label: "Podaj q (Liczba pierwsza)"),
                const SizedBox(height: 16.0),
                CryptoTextInput(controller: pController, label: "Podaj p (Liczba pierwsza)"),
                const SizedBox(height: 16.0),
                CryptoTextInput(controller: textEditingController, label: "Wprowadź tekst do zaszyfrowania"),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    if (!decrypt) {
                      generateAndEncrypt();
                      setState(() {
                        encrypt = true;
                      decrypt = true;
                      });
                    } else {
                      decryptMessage();
                      setState(() {
                        encrypt = false;
                      decrypt = false;
                      });
                    }
                  },
                  child: HammginButton(buttonText: !decrypt ? "Zaszyfruj" : "Odszyfruj"),
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Prostokątny kształt
                      side: const BorderSide(color: Color.fromARGB(255, 49, 104, 51), width: 3),
                    ),
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            logs,
                            style: const TextStyle(
                              color: Colors.green,
                              fontFamily: 'Courier New',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (encryptedMessage != null && encrypt) ...[
                            const SizedBox(height: 8.0),
                            Text(
                              'Zaszyfrowana wiadomość: $encryptedMessage',
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Courier New',
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Klucz prywatny: $privateKey,\nKlucz publiczny: $publicKey,\nTocjent: $tocjent,\nIloczyn p,q: $iloczynPQ',
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Courier New',
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (!encrypt) ...[
                            Text(
                              'Odszyfrowana wiadomość: $decryptedMessageValue',
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Courier New',
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void generateAndEncrypt() {
    try {
      // Pobierz wartości p i q z kontrolerów
      int p = int.parse(pController.text);
      int q = int.parse(qController.text);

      // Wygeneruj klucze
      publicKey = generatePublicKey(p, q);
      privateKey = generatePrivateKey(p, q);

      // Zaszyfruj wiadomość
      List<int> encryptedMessage = encryptMessage(input, publicKey);

      // Zaktualizuj stan
      setState(() {
        logs = 'Logi: Klucze wygenerowane i wiadomość zaszyfrowana.';
        this.encryptedMessage = encryptedMessage;
      });
    } catch (e) {
      setState(() {
        logs = 'Logi: Błąd generowania kluczy lub szyfrowania. Sprawdź wprowadzone dane.';
      });
    }
  }

  List<int> generatePublicKey(int p, int q) {
    int n = p * q;
    iloczynPQ = n;
    int phi = (p - 1) * (q - 1);
    tocjent = phi;
    int e = findE(phi);
    return [n, e];
  }

  List<int> generatePrivateKey(int p, int q) {
    int n = p * q;
    int phi = (p - 1) * (q - 1);
    int e = findE(phi);
    int d = calculateD(e, phi);
    return [n, d];
  }

  List<int> encryptMessage(String message, List<int> publicKey) {
    int n = publicKey[0];
    int e = publicKey[1];

    List<int> encryptedMessage = [];

    for (int i = 0; i < message.length; i++) {
      int charCode = message.codeUnitAt(i);
      int encryptedChar = modPow(charCode, e, n);
      encryptedMessage.add(encryptedChar);
    }

    return encryptedMessage;
  }

  int findE(int phi) {
    int e = 2; // Wybierz początkową wartość dla e

    while (e < phi) {
      if (isCoprime(e, phi)) {
        break;
      }
      e++;
    }

    return e;
  }

  bool isCoprime(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a == 1;
  }

  int calculateD(int e, int phi) {
    int d = 1;

    while ((e * d) % phi != 1) {
      d++;
    }

    return d;
  }

  int modPow(int base, int exponent, int modulus) {
    if (modulus == 1) return 0;

    int result = 1;
    base = base % modulus;

    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = (result * base) % modulus;
      }

      exponent = exponent >> 1;
      base = (base * base) % modulus;
    }

    return result;
  }

  void decryptMessage() {
    try {
      // Pobierz wartości p i q z kontrolerów
      int p = int.parse(pController.text);
      int q = int.parse(qController.text);

      // Wygeneruj klucze prywatne
      List<int> privateKey = generatePrivateKey(p, q);

      // Odszyfruj wiadomość
      List<int> decryptedMessage = decryptMessageHelper(encryptedMessage!, privateKey);

      // Zaktualizuj stan
      setState(() {
        logs = 'Logi: Pomyślnie odszyfrowano wiadomość';
        decryptedMessageValue = String.fromCharCodes(decryptedMessage);
      });
    } catch (e) {
      setState(() {
        logs = 'Logi: Błąd generowania kluczy lub odszyfrowywania. Sprawdź wprowadzone dane.';
      });
    }
  }

  List<int> decryptMessageHelper(List<int> encryptedMessage, List<int> privateKey) {
    int n = privateKey[0];
    int d = privateKey[1];

    List<int> decryptedMessage = [];

    for (int i = 0; i < encryptedMessage.length; i++) {
      int encryptedChar = encryptedMessage[i];
      int decryptedChar = modPow(encryptedChar, d, n);
      decryptedMessage.add(decryptedChar);
    }

    return decryptedMessage;
  }
}
