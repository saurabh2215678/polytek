import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polytek/common/pallete.dart';
import 'package:polytek/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final String assetName = 'assets/images/logo.svg';

  Map<String, String> UserData = {
    'username': 'ggh',
    'password': 'lkj'
  };

  final Widget svg = SvgPicture.asset(
      'assets/images/logo.svg',
      semanticsLabel: 'Acme Logo'
  );

  final Widget prefixUserIcon =  SizedBox(
      width: 12.0,
      height: 12.0,
      child : Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          'assets/images/person.svg',
          semanticsLabel: 'Person Icon',
        ),
      )
  );

  final Widget prefixPassIcon =  SizedBox(
      width: 12.0,
      height: 12.0,
      child : Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          'assets/images/password.svg',
          semanticsLabel: 'Password Icon',
        ),
      )
  );

  Future<void> _saveUserDataToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', UserData['username'] ?? '');
    await prefs.setString('password', UserData['password'] ?? '');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF9F5F4),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                shrinkWrap: true,
                children: <Widget>[
                  svg,
                  const Text(
                    'Visitor Registration APP',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'User Name',
                        prefixIcon: prefixUserIcon,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: prefixPassIcon,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      color: Palette.themePallete,
                      textColor: Color(0xffFFFFFF),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        _saveUserDataToPrefs();
                      },
                      child: Text('Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    )
                  ),
                ],
              ),
            )
        )


    );
  }
}
