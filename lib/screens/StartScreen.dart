import 'package:flutter/cupertino.dart';
import 'package:polytek/screens/HomeScreen.dart';
import 'package:polytek/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedInSF = await prefs.getBool('loggedIn');
    setState(() {
      isLoggedIn = isLoggedInSF ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoggedIn){
      return HomeScreen();
    }else{
      return LoginScreen();
    }

  }
}
