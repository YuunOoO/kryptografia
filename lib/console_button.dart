import 'package:flutter/material.dart';
import 'package:kryptografia/crypto_logic/crypto_type.dart';
import 'package:kryptografia/encrypt_page.dart';

class ConsoleButton extends StatelessWidget {
  final CryptoType cryptoType;

  const ConsoleButton({super.key, required this.cryptoType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  EncryptPage(cryptoType: cryptoType,)));
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
