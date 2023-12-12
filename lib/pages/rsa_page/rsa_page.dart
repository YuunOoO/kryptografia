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
  late List<BigInt> publicKey;
  late List<BigInt> privateKey;
  BigInt tocjent = BigInt.zero;
  BigInt iloczynPQ = BigInt.zero;
  List<BigInt>? encryptedMessage;
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
      BigInt p = BigInt.parse(pController.text);
      BigInt q = BigInt.parse(qController.text);

      // Wygeneruj klucze
      publicKey = generatePublicKey(p, q);
      privateKey = generatePrivateKey(p, q);

      // Zaszyfruj wiadomość
      List<BigInt> encryptedMessage = encryptMessage(input, publicKey);

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

  List<BigInt> generatePublicKey(BigInt p, BigInt q) {
    BigInt n = p * q;
    iloczynPQ = n;
    BigInt phi = (p - BigInt.one) * (q - BigInt.one);
    tocjent = phi;
    BigInt e = findE(phi);
    return [n, e];
  }

  List<BigInt> generatePrivateKey(BigInt p, BigInt q) {
    BigInt n = p * q;
    BigInt phi = (p - BigInt.one) * (q - BigInt.one);
    BigInt e = findE(phi);
    BigInt d = calculateD(e, phi);
    return [n, d];
  }

  List<BigInt> encryptMessage(String message, List<BigInt> publicKey) {
  BigInt n = publicKey[0];
  BigInt e = publicKey[1];

  List<BigInt> encryptedMessage = [];

  for (int i = 0; i < message.length; i++) {
    int charCode = message.codeUnitAt(i);
    BigInt encryptedChar = modPow(BigInt.from(charCode), e, n);
    encryptedMessage.add(encryptedChar);
  }

  return encryptedMessage;
}

BigInt findE(BigInt phi) {
  BigInt e = BigInt.two; // Wybierz początkową wartość dla e

  while (e < phi) {
    if (isCoprime(e, phi)) {
      break;
    }
    e += BigInt.one;
  }

  return e;
}

bool isCoprime(BigInt a, BigInt b) {
  while (b != BigInt.zero) {
    BigInt temp = b;
    b = a % b;
    a = temp;
  }
  return a == BigInt.one;
}

BigInt calculateD(BigInt e, BigInt phi) {
  BigInt d = BigInt.one;

  while ((e * d) % phi != BigInt.one) {
    d += BigInt.one;
  }

  return d;
}

BigInt modPow(BigInt base, BigInt exponent, BigInt modulus) {
  if (modulus == BigInt.one) return BigInt.zero;

  BigInt result = BigInt.one;
  base = base % modulus;

  while (exponent > BigInt.zero) {
    if (exponent % BigInt.two == BigInt.one) {
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
    BigInt p = BigInt.parse(pController.text);
    BigInt q = BigInt.parse(qController.text);

    // Wygeneruj klucze prywatne
    List<BigInt> privateKey = generatePrivateKey(p, q);

    // Odszyfruj wiadomość
    List<BigInt> decryptedMessage = decryptMessageHelper(encryptedMessage!, privateKey);

    // Zaktualizuj stan
    setState(() {
      logs = 'Logi: Pomyślnie odszyfrowano wiadomość';
      decryptedMessageValue = String.fromCharCodes(decryptedMessage.map((e) => e.toInt()));
    });
  } catch (e) {
    setState(() {
      logs = 'Logi: Błąd generowania kluczy lub odszyfrowywania. Sprawdź wprowadzone dane.';
    });
  }
}

List<BigInt> decryptMessageHelper(List<BigInt> encryptedMessage, List<BigInt> privateKey) {
  BigInt n = privateKey[0];
  BigInt d = privateKey[1];

  List<BigInt> decryptedMessage = [];

  for (int i = 0; i < encryptedMessage.length; i++) {
    BigInt encryptedChar = encryptedMessage[i];
    BigInt decryptedChar = modPow(encryptedChar, d, n);
    decryptedMessage.add(decryptedChar);
  }

  return decryptedMessage;
}

}
