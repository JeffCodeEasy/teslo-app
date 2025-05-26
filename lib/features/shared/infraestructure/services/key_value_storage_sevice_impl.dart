import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infraestructure/services/key_value_storage_service.dart';

class KeyValueStorageSeviceImpl extends KeyValueStorageService {
  
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  Future<T?> getValue<T>(String key) async{
     switch (T) {
      case int:
        return await asyncPrefs.getDouble(key) as T?;
        

      case String:
        return await asyncPrefs.getString(key) as T?;
        

      default:
        throw UnimplementedError('Set bit implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<void> removeKey(String key) async {
    return await asyncPrefs.remove(key);
  }


  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    switch (T) {
      case int:
        await asyncPrefs.setInt(key, value as int);
        break;

      case String:
        await asyncPrefs.setString(key, value as String);
        break;

      default:
        throw UnimplementedError('Set bit implemented for type ${T.runtimeType}');
    }
  }
}
