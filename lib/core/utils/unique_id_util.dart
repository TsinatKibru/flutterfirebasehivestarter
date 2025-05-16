import 'dart:math';

class UniqueIdUtil {
  static String generateSimpleId() {
    final nowHex = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    final randHex = Random().nextInt(0xFFFFF).toRadixString(16).padLeft(5, '0');
    return '$nowHex-$randHex';
  }

  static String generateRandomSuffix(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
