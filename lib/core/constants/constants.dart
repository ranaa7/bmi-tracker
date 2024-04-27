import '../network/cache_helper.dart';

class AppConstants {
  static bool isStudent = CacheHelper.getData(key: 'isStudent') ?? false;


  // <<--- key SharedPreferences --->>
  static const String userData = '';

}
