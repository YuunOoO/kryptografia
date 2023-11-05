import 'package:flutter/material.dart';

class CryptoCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CryptoCodeInput({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8,left: 50,right: 50,top: 2),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Prostokątny kształt
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.vpn_key,
                color: Colors.green,
              ),
              const SizedBox(width: 8), // Odstęp między ikonką a tekstem
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
