import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polytek/screens/AddVisitorScreen.dart';
import 'package:polytek/screens/LoginScreen.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

Map<String, dynamic> parseVCard(String vCardData) {
  List<String> lines = vCardData.split('\n');
  Map<String, dynamic> vCardMap = {};

  String? name;
  String? org;
  String? email;
  String? phone;
  String? country;

  for (String line in lines) {
    if (line.isNotEmpty) {
      List<String> parts = line.split(':');
      if (parts.length >= 2) {
        String key = parts[0].trim().toLowerCase();
        String value = parts.sublist(1).join(':').trim();

        if (key == 'n') {
          List<String> nameParts = value.split(';');
          if (nameParts.length >= 2) {
            name = '${nameParts[1]} ${nameParts[0]}'; // Reversed order
          }
        } else if (key == 'org') {
          org = value;
        } else if (key == 'email') {
          List<String> emailParts = value.split(':');
          if (emailParts.length >= 2) {
            email = emailParts[1]; // Extract email
          }
        } else if (key == 'tel') {
          // Extract only if no specific type is mentioned
          if (value.startsWith('TEL:')) {
            phone = value.split(':')[1];
          }
        } else if (key == 'adr') {
          List<String> addressParts = value.split(';');
          if (addressParts.length > 6) {
            country = addressParts[6];
          }
        }
      }
    }
  }

  if (name != null) vCardMap['name'] = name;
  if (org != null) vCardMap['org'] = org;
  if (email != null) vCardMap['email'] = email;
  if (phone != null) vCardMap['phone'] = phone;
  if (country != null) vCardMap['country'] = country;

  return vCardMap;
}


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

Future<void> _logOutFn(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('loggedIn', false);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

Future<void> _scanQrCodeFn(context) async {
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

  String? cameraScanResult = await scanner.scan();
  // print('camera result ==');
  // print(cameraScanResult);
  if(cameraScanResult != null){

    // Contact contact = Contact.fromMap(FlutterContacts.vcardToMap(vCardContent));
    // Map<String, dynamic> contactMap = FlutterContacts.vcardToMap(vCardContent);

    Map<String, dynamic> vCardMap = parseVCard(cameraScanResult);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVisitorScreen(
          visitorData: vCardMap,
        ),
      ),
    );
    print('vCardMap result ==');
    print(vCardMap);
  }

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
              _logOutFn(context);
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
                _scanQrCodeFn(context);
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
