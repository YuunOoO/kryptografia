import 'package:flutter/material.dart';

class CryptoEncryptButton extends StatelessWidget {


  const CryptoEncryptButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .4,
      child: const Material(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          side: BorderSide(color: Colors.red, width: 1),
        ),
        color: Colors.black,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Zaszyfruj",
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Courier New',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.red,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
