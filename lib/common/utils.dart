import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DataUtils {
  static List<String> staticList = ['Item 1', 'Item 2', 'Item 3'];

  static String BaseUri = 'https://polyteksynergy.tekzini.com/api/v1';

  static Map<String, String> UserData = {
    'username': 'polytek',
    'password': 'synergy@2024'
  };
}

Future<bool> isInternetAvailable() async {
  late bool conection = false;
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    conection = true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    conection = true;
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    conection = true;
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    conection = true;
  } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
    // Bluetooth connection available.
  } else if (connectivityResult.contains(ConnectivityResult.other)) {
    // Connected to a network which is not in the above mentioned networks.
  } else if (connectivityResult.contains(ConnectivityResult.none)) {
    conection = false;
  }
  return conection;
}


class Exhibition {
  final int id;
  final String title;

  Exhibition({required this.id, required this.title});
}

class Customer {
  final int id;
  final String title;

  Customer({required this.id, required this.title});
}

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});
}

class ProductSegment {
  final int id;
  final String title;

  ProductSegment({required this.id, required this.title});
}

Future<void> _saveDatabyApi(exbValue, remark, customerType, companyName, name, designation, email, phone, country, product, doc) async {

  var request = http.MultipartRequest('POST',
      Uri.parse('https://polyteksynergy.tekzini.com/api/v1/saveAppEnquiry'));
  request.fields.addAll({
    'exhibition_id': '$exbValue',
    'remark': '$remark',
    'customer_type': '$customerType',
    'company_name': '$companyName',
    'name': '$name',
    'designation': '$designation',
    'email': '$email',
    'phone': '$phone',
    'country_id': '$country',
    'product_id': '$product',
  });

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print('success');
    doc.reference.delete();
    print(await response.stream.bytesToString());

  } else {
    print('error .reasonPhrase');
    print(response.reasonPhrase);
  }
}


Future<void> getEnquariesFromFirebase(bool setData) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('enquiries')
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    for (DocumentSnapshot doc in querySnapshot.docs) {
      final dynamic docData = doc.data();
      if (docData != null && docData is Map<dynamic, dynamic>) {

        await _saveDatabyApi(docData['exbValue'], docData['remark'], docData['customerType'], docData['companyName'], docData['name'], docData['designation'], docData['email'], docData['phone'], docData['country'], docData['product'], doc);
        // allData.add(Map<dynamic, dynamic>.from(docData));
      }
    }
  }
}