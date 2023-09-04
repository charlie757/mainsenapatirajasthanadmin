import 'package:shared_preferences/shared_preferences.dart';

setUserLogin(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLogin', value);
}
