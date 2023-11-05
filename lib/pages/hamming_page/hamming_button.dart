import 'package:flutter/material.dart';

class HammginButton extends StatelessWidget {
  final String buttonText;

  const HammginButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Material(
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
              buttonText,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier New',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
