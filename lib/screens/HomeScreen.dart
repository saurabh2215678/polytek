import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polytek/screens/AddVisitorScreen.dart';
import 'package:polytek/screens/LoginScreen.dart';
import 'package:polytek/screens/ScannerScreen.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final Widget svg = SvgPicture.asset(
    'assets/images/logo-icon.svg',
    semanticsLabel: 'Logo'
);

final Widget LogoutBtn = SvgPicture.asset(
    'assets/images/logout.svg',
    semanticsLabel: 'Logout btn'
);

final Widget VisitorIcon = SvgPicture.asset(
    'assets/images/visitor.svg',
    semanticsLabel: 'Visitor'
);

final Widget BarIcon = SvgPicture.asset(
    'assets/images/bar.svg',
    semanticsLabel: 'qr code'
);

Future<void> _scanQrCodeFn() async {
  // Check if camera permission is granted
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    // Request camera permission
    status = await Permission.camera.request();
    if (!status.isGranted) {
      // If permission still not granted, return
      return;
    }
  }
  print('cameraScanResult start ==');
  // Proceed with scanning
  String? cameraScanResult = await scanner.scan();
  print('cameraScanResult ==');
  print(cameraScanResult);
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F5F4),
      appBar: AppBar(
        title: SizedBox(
          width: 40,
          child: svg,
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
        padding: EdgeInsets.fromLTRB(40, 80, 40, 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVisitorScreen()),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffE65E24),
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: VisitorIcon,
              ),
            ),
            SizedBox(width: 40),
            InkWell(
              onTap: () {
                _scanQrCodeFn();
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffE65E24),
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: BarIcon,
              ),
            )
          ],
        ),
      )
    );
  }
}
