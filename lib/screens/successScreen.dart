import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polytek/common/pallete.dart';
import 'package:polytek/screens/AddVisitorScreen.dart';
import 'package:polytek/screens/LoginScreen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

final Widget LogoutBtn = SvgPicture.asset(
    'assets/images/logout.svg',
    semanticsLabel: 'Logout btn'
);

final Widget Thankyoucontent = SvgPicture.asset(
    'assets/images/thankyou.svg',
    semanticsLabel: 'thankyou btn'
);

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F5F4),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color(0xffffffff)
        ),
        backgroundColor: Color(0xff10773F),
        actions: <Widget>[
          // Your button placed at the end of the AppBar
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: LogoutBtn,
              ),
            ),
          ),
          SizedBox(
            width: 18,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child:
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Thankyoucontent,
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Palette.themePallete, // You can change the color of the border
                    width: 1.0, // You can adjust the width of the border
                  ),
                  borderRadius: BorderRadius.circular(5.0), // You can adjust the border radius
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.transparent,
                  elevation: 0,
                  textColor: Palette.themePallete,
                  padding: EdgeInsets.all(12),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddVisitorScreen()),
                    );
                  },
                  child: Text('Add More Visitor',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
