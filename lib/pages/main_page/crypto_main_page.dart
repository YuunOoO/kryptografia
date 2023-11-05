import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kryptografia/pages/main_page/console_button.dart';
import 'package:kryptografia/crypto_logic/crypto_type.dart';

class CryptoMainPage extends StatefulWidget {
  const CryptoMainPage({super.key});

  @override
  State<CryptoMainPage> createState() => _CryptoMainPageState();
}

class _CryptoMainPageState extends State<CryptoMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
              child: Center(child: Image.asset("assets/crypto.gif"))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: AnimatedTextKit(repeatForever: true, pause: const Duration(seconds: 3), animatedTexts: [
                    TypewriterAnimatedText('Kryptografia',
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 60, 143, 63),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier New',
                        ),
                        speed: const Duration(milliseconds: 300)),
                  ]),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        ConsoleButton(
                          cryptoType: CryptoType.caesar,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ConsoleButton(
                          cryptoType: CryptoType.transpozition,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ConsoleButton(
                          cryptoType: CryptoType.polyalphabetic,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ConsoleButton(
                          cryptoType: CryptoType.hamming,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ConsoleButton(
                          cryptoType: CryptoType.base64,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
