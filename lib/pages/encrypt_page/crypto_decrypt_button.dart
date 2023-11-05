import 'package:flutter/material.dart';

class CryptoDecryptButton extends StatelessWidget {

  const CryptoDecryptButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .4,
      child: const Material(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          side: BorderSide(color: Colors.purple, width: 1),
        ),
        color: Colors.black,
        child: Row(
          children: [
             Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.purple,
                size: 24,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Odszyfruj",
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Courier New',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
