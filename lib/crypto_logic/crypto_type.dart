enum CryptoType { caesar, polyalphabetic, transpozition, base64, hamming, rsa}

extension CryptoTypeTypeExtension on CryptoType {
  String get type {
    switch (this) {
      case CryptoType.caesar:
        return 'Szyfr Cezara';
      case CryptoType.polyalphabetic:
        return 'Polialfabetyczny';
      case CryptoType.transpozition:
        return "Transpozycja";
      case CryptoType.base64:
        return "Base64";
      case CryptoType.hamming:
        return "Hamminga";
        case CryptoType.rsa:
        return "RSA";
    }
  }
}