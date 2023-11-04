import 'package:flutter/material.dart';

class CryptoInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CryptoInput({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white, width: 1),
        ),
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.green,
              fontFamily: 'Courier New',
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(
                color: Colors.green,
                fontFamily: 'Courier New',
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
