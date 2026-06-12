import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwm/core/utils/crypt_util.dart';

class SecureStore {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _masterKey = 'secrets_master_key';

  Future<void> saveMasterKey(String masterKey) async =>
      await _storage.write(key: _masterKey, value: masterKey);

  Future<bool> validateMasterKey(String enteredKey) async {
    // final mKey = await _storage.read(key: _masterKey);
    // if (mKey == null) return false;
    // TODO only for testing purpose should enable previous comments
    // and atore masterkey out side of the app like admin login or during the setup
    final mKey = CryptoUtil.fastHash("D@y@@123");
    return mKey == enteredKey;
  }
}
