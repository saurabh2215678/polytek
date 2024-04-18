import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {

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

    // Proceed with scanning
    String? cameraScanResult = await scanner.scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF9F5F4),
        appBar: AppBar(
          title: Text('scanner txt'),
          backgroundColor: Color(0xff10773F),
          actions: <Widget>[
            // Your button placed at the end of the AppBar
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Text('scanner txt'),
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
          child: MaterialButton(
            onPressed: (){
              _scanQrCodeFn();
            },
            child: Text('scan now'),
          ),
        )
    );
  }
}
