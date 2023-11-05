import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_code_input.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_decrypt_button.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_encrypt_button.dart';
import 'package:kryptografia/pages/encrypt_page/crypto_text_input.dart';
import 'package:kryptografia/crypto_logic/crypto_logic.dart';
import 'package:kryptografia/crypto_logic/crypto_type.dart';

class EncryptPage extends StatefulWidget {
  const EncryptPage({super.key, required this.cryptoType});

  final CryptoType cryptoType;

  @override
  State<EncryptPage> createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  final TextEditingController textInputController = TextEditingController();
  final TextEditingController codeInputController = TextEditingController();
  String topText = "Consola";
  String bottomText = "";
  String codedText = "";
  CryptoLogic cryptoLogic = CryptoLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .35),
                child: Center(child: Image.asset("assets/crypto.gif"))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .95,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        child: AnimatedTextKit(repeatForever: true, pause: const Duration(seconds: 3), animatedTexts: [
                          TypewriterAnimatedText(widget.cryptoType.type,
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 60, 143, 63),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier New',
                              ),
                              speed: const Duration(milliseconds: 300)),
                        ]),
                      ),
                    ),
                    CryptoTextInput(controller: textInputController, label: "Podaj tekst do zaszyfrowania"),
                    if (widget.cryptoType != CryptoType.base64)
                      CryptoCodeInput(
                        label: "Podaj kod",
                        controller: codeInputController,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (codedText.isEmpty) {
                                topText = "Nie zaszyfrowałeś / nie zakodowałeś jeszcze wiadomości";
                                return;
                              }
                              if (widget.cryptoType == CryptoType.caesar ||
                                  widget.cryptoType == CryptoType.transpozition) {
                                final number = int.tryParse(codeInputController.text);
                                if (number == null) {
                                  topText = "Kod musi być liczbą";
                                  return;
                                }
                              }
                              setState(() {
                                topText =
                                    "Odszyfrowana / odkodowana wiadomość, za pomocą klucza ${codeInputController.text} to:";

                                switch (widget.cryptoType) {
                                  case CryptoType.caesar:
                                    bottomText = cryptoLogic.caesarEncryptDecrypt(
                                        codedText, int.parse(codeInputController.text), false);
                                    break;
                                  case CryptoType.polyalphabetic:
                                    bottomText = cryptoLogic.polyalphabeticEncryptDecrypt(
                                        codedText, codeInputController.text, false);
                                    break;
                                  case CryptoType.transpozition:
                                    bottomText = cryptoLogic.transpositionDecrypt(
                                        codedText, int.parse(codeInputController.text));
                                  case CryptoType.base64:
                                    bottomText = cryptoLogic.customBase64Decode(codedText);
                                    topText = "Odkodowana wiadomość Base64:";
                                  default:
                                    break;
                                  // Dodaj inne przypadki, jeśli masz więcej rodzajów szyfrowania
                                }
                              });
                            },
                            child: const CryptoDecryptButton()),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (widget.cryptoType == CryptoType.base64) {
                                  if (textInputController.text.isEmpty) {
                                    topText = "Podaj tekst do zakodowania";
                                    return;
                                  }
                                } else {
                                  if (codeInputController.text.isEmpty || textInputController.text.isEmpty) {
                                    topText = "Podaj tekst do zaszyfrowania oraz kod";
                                    return;
                                  }
                                }

                                if (widget.cryptoType == CryptoType.caesar ||
                                    widget.cryptoType == CryptoType.transpozition) {
                                  final number = int.tryParse(codeInputController.text);
                                  if (number == null) {
                                    topText = "Kod musi być liczbą";
                                    return;
                                  }
                                }
                                topText =
                                    "Zaszyfrowana wiadomość, za pomocą klucza //${codeInputController.text}// to:";
                                switch (widget.cryptoType) {
                                  case CryptoType.caesar:
                                    bottomText = cryptoLogic.caesarEncryptDecrypt(
                                        textInputController.text, int.parse(codeInputController.text), true);
                                    break;
                                  case CryptoType.polyalphabetic:
                                    bottomText = cryptoLogic.polyalphabeticEncryptDecrypt(
                                        textInputController.text, codeInputController.text, true);
                                    break;
                                  case CryptoType.transpozition:
                                    bottomText = cryptoLogic.transpositionEncrypt(
                                        textInputController.text, int.parse(codeInputController.text));
                                    break;
                                  case CryptoType.base64:
                                    bottomText = cryptoLogic.customBase64Encode(textInputController.text);
                                    topText = "Zakodowana wiadomość w Base64:";
                                  default:
                                    break;
                                  // Dodaj inne przypadki, jeśli masz więcej rodzajów szyfrowania
                                }
                                codedText = bottomText;
                              });
                            },
                            child: const CryptoEncryptButton()),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * .15,
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
                            children: [
                              Text(
                                topText,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontFamily: 'Courier New',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                bottomText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Courier New',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
