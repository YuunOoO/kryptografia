import 'package:flutter/material.dart';
import 'package:kryptografia/crypto_logic/crypto_type.dart';
import 'package:kryptografia/pages/encrypt_page/encrypt_page.dart';
import 'package:kryptografia/pages/hamming_page/hamming_page.dart';
import 'package:kryptografia/pages/rsa_page/rsa_page.dart';

class ConsoleButton extends StatelessWidget {
  final CryptoType cryptoType;

  const ConsoleButton({super.key, required this.cryptoType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cryptoType != CryptoType.hamming && cryptoType != CryptoType.rsa) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EncryptPage(
                    cryptoType: cryptoType,
                  )));
        } else if (cryptoType == CryptoType.rsa) {
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RsaPage()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HammingCodeScreen()));
        }
      },
      child: Material(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: Colors.white, width: 1),
        ),
        color: Colors.black, // Tło czarne
        child: SizedBox(
          height: 50,
          width: 160,
          child: Center(
            child: Center(
              child: Text(
                cryptoType.type,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier New',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
