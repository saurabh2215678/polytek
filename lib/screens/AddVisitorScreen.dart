import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polytek/common/pallete.dart';
import 'package:polytek/screens/HomeScreen.dart';
import 'package:polytek/screens/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:polytek/common/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:polytek/screens/successScreen.dart';

class AddVisitorScreen extends StatefulWidget {
  final Contact? visitorData;
  const AddVisitorScreen({Key? key, this.visitorData}) : super(key: key);

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

final Widget LogoutBtn = SvgPicture.asset(
    'assets/images/logout.svg',
    semanticsLabel: 'Logout btn'
);

final Widget ExhibitionIcon =  SizedBox(
    width: 30,
    height: 30,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/1.svg',
        semanticsLabel: 'Exhibition Icon',
      ),
    )
);

final Widget CompanyIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/2.svg',
        semanticsLabel: 'Exhibition Icon',
      ),
    )
);

final Widget UserIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/person.svg',
        semanticsLabel: 'User Icon',
      ),
    )
);

final Widget DesignationIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/4.svg',
        semanticsLabel: 'Designation Icon',
      ),
    )
);

final Widget EmailIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/5.svg',
        semanticsLabel: 'Email Icon',
      ),
    )
);

final Widget PhoneIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/6.svg',
        semanticsLabel: 'Phone Icon',
      ),
    )
);

final Widget CountryIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/7.svg',
        semanticsLabel: 'Country Icon',
      ),
    )
);

final Widget ProductSegmentIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/8.svg',
        semanticsLabel: 'Product Segment Icon',
      ),
    )
);

final Widget RemarkIcon =  SizedBox(
    width: 20,
    height: 20,
    child : Padding(
      padding: const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/images/9.svg',
        semanticsLabel: 'Remark Icon',
      ),
    )
);



class _AddVisitorScreenState extends State<AddVisitorScreen> {

  List<Exhibition> Exhibitionlist = <Exhibition>[Exhibition(id: -1, title: 'Exhibition Name')];
  late Exhibition ExhibitionValue = Exhibitionlist.first;

  List<Customer> CustomerTypelist = <Customer>[Customer(id: -1, title: 'Customer Type')];
  late Customer CustomerTypeValue = CustomerTypelist.first;

  List<Country> Countrylist = <Country>[Country(id: -1, name: 'Country')];
  late Country CountryValue = Countrylist.first;

  List<ProductSegment> ProductSegmentlist = <ProductSegment>[ProductSegment(id: -1, title: 'Product Segment')];
  late ProductSegment ProductSegmentValue = ProductSegmentlist.first;

  String _comapnyValue = '';
  String _nameValue = '';
  String _designationValue = '';
  String _phoneValue = '';
  String _emailValue = '';
  String _remarkValue = '';
  bool internetConnected = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _imageName;

  bool ExbErr = false;
  bool customerErr = false;
  bool NameErr = false;
  bool PhoneErr = false;
  bool ProductErr = false;

  bool formSubmitted = false;
  bool formSubmitting = false;

  @override
  void initState() {
    super.initState();
    if(widget.visitorData != null){
      print('widget.visitorData');

      Contact? visitorData = widget.visitorData;
      print(visitorData?.toJson());
      setState(() {
        if(visitorData?.displayName != ''){
          _nameValue = visitorData?.displayName ?? '';
        }else{
          _nameValue = '${visitorData?.name?.first} ${visitorData?.name?.last}' ?? '';
        }

        _phoneValue = visitorData?.phones?.first?.number ?? '';
        _designationValue = visitorData?.organizations?.first?.department ?? '';
        _emailValue = visitorData?.emails?.first?.address ?? '';
        _comapnyValue = visitorData?.organizations?.first?.company ?? '';
        if(visitorData?.addresses != null){
          if(visitorData!.addresses.length > 0){

            print('visitorData?.addresses?.first?.address');
            // print(visitorData?.addresses?.first?.address);
            _remarkValue = visitorData?.addresses?.first?.address ?? '';
          }
        }

      });
    }
    // getEnquariesFromFirebase(true);
    _getExhibitionFn();
    _getCustomerFn();
    _getCountryFn();
    _getProductSegmentFn();

    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {

      if (result.contains(ConnectivityResult.mobile)) {
        setState(() {
          internetConnected = true;
        });
      } else if (result.contains(ConnectivityResult.none)) {
        setState(() {
          internetConnected = false;
        });
      }
    });
  }

  Future<void> updateExhibitionToFirebase(jsonExhibitionList) async {
    final List<dynamic> exhibitionList = jsonExhibitionList;
    final collectionReference = FirebaseFirestore.instance.collection('exhibition-list');

    try {
      final querySnapshot = await collectionReference.get();
      final List<String> existingIds = [];

      for (final doc in querySnapshot.docs) {
        final id = doc.data()['id'].toString();
        if (exhibitionList.any((exhibition) => exhibition['id'].toString() == id)) {
          await doc.reference.update(exhibitionList.firstWhere((exhibition) => exhibition['id'].toString() == id));
          print('Document with ID $id updated successfully.');
        } else {
          await doc.reference.delete();
          print('Document with ID $id deleted successfully.');
        }
        existingIds.add(id);
      }

      for (final exhibition in exhibitionList) {
        final id = exhibition['id'].toString();
        if (!existingIds.contains(id)) {
          await collectionReference.add(exhibition);
          print('Document with ID $id inserted successfully.');
        }
      }
    } catch (e) {
      print('Error updating documents: $e');
    }
  }

  Future<void> updateCustomerToFirebase(jsonCustomerList) async {
    final List<dynamic> customerList = jsonCustomerList;
    final collectionReference = FirebaseFirestore.instance.collection('customer-list');

    try {
      final querySnapshot = await collectionReference.get();
      final List<String> existingIds = [];

      for (final doc in querySnapshot.docs) {
        final id = doc.data()['id'].toString();
        if (customerList.any((customer) => customer['id'].toString() == id)) {
          await doc.reference.update(customerList.firstWhere((customer) => customer['id'].toString() == id));
          print('Document with ID $id updated successfully.');
        } else {
          await doc.reference.delete();
          print('Document with ID $id deleted successfully.');
        }
        existingIds.add(id);
      }

      for (final customer in customerList) {
        final id = customer['id'].toString();
        if (!existingIds.contains(id)) {
          await collectionReference.add(customer);
          print('Document with ID $id inserted successfully.');
        }
      }
    } catch (e) {
      print('Error updating documents: $e');
    }
  }

  Future<void> updateCountryToFirebase(jsonCountryList) async {
    final List<dynamic> countryList = jsonCountryList;
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('country-list');

    // Delete all existing documents in the collection
    QuerySnapshot snapshot = await collectionReference.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Add a single document with all countries
    await collectionReference.add({'countries': countryList});
  }

  Future<void> updateProductToFirebase(jsonProductList) async {
    final List<dynamic> productList = jsonProductList;
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('product-list');

    QuerySnapshot snapshot = await collectionReference.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }

    await collectionReference.add({'products': productList});
  }

  Future<void> getExhibitionFromFirebase(bool setData) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('exhibition-list')
        .get();
    List<Map<dynamic, dynamic>> allData = [];
    for (DocumentSnapshot doc in querySnapshot.docs) {
      final dynamic docData = doc.data();
      if (docData != null && docData is Map<dynamic, dynamic>) {
        allData.add(Map<dynamic, dynamic>.from(docData)); // Convert to Map<String, dynamic>
      }
    }
    var jsonData = jsonEncode(allData);
    var jsonDecodedData = jsonDecode(jsonData);
    setExhibitionFronJson(jsonDecodedData);
  }

  Future<void> getCustomerFromFirebase(bool setData) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('customer-list')
        .get();
    List<Map<dynamic, dynamic>> allData = [];
    for (DocumentSnapshot doc in querySnapshot.docs) {
      final dynamic docData = doc.data();
      if (docData != null && docData is Map<dynamic, dynamic>) {
        allData.add(Map<dynamic, dynamic>.from(docData)); // Convert to Map<String, dynamic>
      }
    }
    var jsonData = jsonEncode(allData);
    var jsonDecodedData = jsonDecode(jsonData);
    setCustomerFromJson(jsonDecodedData);
  }

  Future<void> getCountryFromFirebase(bool setData) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('country-list')
        .get();

    if (querySnapshot.docs.isNotEmpty) {

      DocumentSnapshot firstDoc = querySnapshot.docs.first;

      dynamic? countriesData = (firstDoc.data() as Map<dynamic, dynamic>?)?['countries'];
      setCountryFromJson(countriesData);
    }
  }

  Future<void> getProductsFromFirebase(bool setData) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('product-list')
        .get();

    if (querySnapshot.docs.isNotEmpty) {

      DocumentSnapshot firstDoc = querySnapshot.docs.first;

      dynamic? productsData = (firstDoc.data() as Map<dynamic, dynamic>?)?['products'];
      setProductFromJson(productsData);
    }
  }

  void setExhibitionFronJson(data){
    var exhibitionsData = data as List;

    var exhibitions = exhibitionsData.map((exhibitionData) => Exhibition(
      id: exhibitionData['id'],
      title: exhibitionData['title'],
    )).toList();

    setState(() {
      Exhibitionlist = exhibitions;
      ExhibitionValue = exhibitions.first;
    });
  }

  void setCustomerFromJson(data) {
    var customerData = data as List;
    bool idMinusOneExists = customerData.any((customer) => customer['id'] == -1);
    if (!idMinusOneExists) {
      customerData.insert(0, {'id': -1, 'title': 'Customer Type'});
    }

    var customer = customerData.map((customerData) => Customer(
      id: customerData['id'],
      title: customerData['title'],
    )).toList();

    setState(() {
      CustomerTypelist = customer;
      CustomerTypeValue = customer.first;
    });
  }

  void setCountryFromJson(data) {
    var countryData = data as List;
    bool idMinusOneExists = countryData.any((country) => country['id'] == -1);
    if (!idMinusOneExists) {
      countryData.insert(0, {'id': -1, 'name': 'Country'});
    }

    var country = countryData.map((countryData) => Country(
      id: countryData['id'],
      name: countryData['name'],
    )).toList();
    setState(() {
      Countrylist = country;
      CountryValue = country.first;
    });
  }

  void setProductFromJson(data) {
    var productData = data as List;
    bool idMinusOneExists = productData.any((product) => product['id'] == -1);
    if (!idMinusOneExists) {
      productData.insert(0, {'id': -1, 'title': 'Product Segment'});
    }

    var product = productData.map((productData) => ProductSegment(
      id: productData['id'],
      title: productData['display_title'] ?? 'Product Segment',
    )).toList();
    setState(() {
      ProductSegmentlist = product;
      ProductSegmentValue = product.first;
    });
  }

  Future<void> _getExhibitionFn() async {
    var BaseUri = DataUtils.BaseUri;
    var netConected = await isInternetAvailable();
    if(!netConected){
      getExhibitionFromFirebase(true);
      return;
    }

    var request = http.Request('POST', Uri.parse('$BaseUri/getExhibitions'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      setExhibitionFronJson(jsonResponse['exhibition_list']);
      updateExhibitionToFirebase(jsonResponse['exhibition_list']);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _getCustomerFn() async {
    var BaseUri = DataUtils.BaseUri;
    var netConected = await isInternetAvailable();
    if(!netConected){
      getCustomerFromFirebase(true);
      return;
    }
    var request = http.Request('POST', Uri.parse('$BaseUri/getCustomerType'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      setCustomerFromJson(jsonResponse['customer_type']);
      updateCustomerToFirebase(jsonResponse['customer_type']);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _getCountryFn() async {
    var BaseUri = DataUtils.BaseUri;
    var netConected = await isInternetAvailable();
    if(!netConected){
      getCountryFromFirebase(true);
      return;
    }
    var request = http.Request('POST', Uri.parse('$BaseUri/getCountry'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      setCountryFromJson(jsonResponse['country_list']);
      updateCountryToFirebase(jsonResponse['country_list']);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _getProductSegmentFn() async {
    var BaseUri = DataUtils.BaseUri;
    var netConected = await isInternetAvailable();
    if(!netConected){
      // getExhibitionFromFirebase(true);
      getProductsFromFirebase(true);
      return;
    }
    var request = http.Request('POST', Uri.parse('$BaseUri/getProducts'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      setProductFromJson(jsonResponse['product_list']);
      updateProductToFirebase(jsonResponse['product_list']);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        _imageName = image != null ? image.name.split('/').last : null;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _validateAndSubmitForm() async {
    if(!formSubmitted){
      return;
    }
    if(ExhibitionValue.id == -1){
      setState(() {
        ExbErr = true;
      });
    }else{
      setState(() {
        ExbErr = false;
      });
    }

    if(CustomerTypeValue.id == -1){
      print('country not selected');
      setState(() {
        customerErr = true;
      });
    }else{
      setState(() {
        customerErr = false;
      });
    }

    if(_nameValue == ''){
      setState(() {
        NameErr = true;
      });
    }else{
      setState(() {
        NameErr = false;
      });
    }

    if(_phoneValue == ''){
      setState(() {
        PhoneErr = true;
      });
    }else{
      setState(() {
        PhoneErr = false;
      });
    }

    if(ProductSegmentValue.id == -1){
      setState(() {
        ProductErr = true;
      });
    }else{
      setState(() {
        ProductErr = false;
      });
    }
  }

  Future<void> _saveDatabyApi(exbValue, remark, customerType, companyName, name, designation, email, phone, country, product, imageFile) async {

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

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('images[]', imageFile.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('success');
      print(await response.stream.bytesToString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } else {
      print('error .reasonPhrase');
      print(response.reasonPhrase);
    }
  }

  Future<void> _saveDatatoFirebase(exbValue, remark, customerType, companyName, name, designation, email, phone, country, product, imageFile, savedByApi) async {

    Map<String, dynamic> formData = {
      'exbValue': exbValue,
      'customerType': customerType,
      'companyName': companyName,
      'name': name,
      'designation': designation,
      'email': email,
      'remark': remark,
      'phone': phone,
      'country': country,
      'product': product,
      'savedByApi': savedByApi,
      'timestamp': FieldValue.serverTimestamp(), // Include a timestamp
    };
    var netConected = await isInternetAvailable();
    // If an image is provided, save it to Firebase Storage and include its URL in the form data
    if (imageFile != null && netConected) {
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}');

      await storageReference.putFile(File(imageFile.path));

      // Obtain download URL
      String imageUrl = await storageReference.getDownloadURL();

      formData['imageUrl'] = imageUrl; // Include the download URL of the image
    }

    // Save data to Firestore
    await FirebaseFirestore.instance.collection('enquiries').add(formData);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen()),
    );
    print('Form data submitted successfully!');
  }



  Future<void> _SubmitForm() async {
    setState(() {
      formSubmitted = true;
    });
    _validateAndSubmitForm();
    var netConected = await isInternetAvailable();
    if (!ExbErr && !customerErr && !NameErr && !PhoneErr && !ProductErr) {
      setState(() {
        formSubmitting = true;
      });
      int exbValue = ExhibitionValue.id;
      String customerType = CustomerTypeValue.title;
      String companyName = _comapnyValue;
      String name = _nameValue;
      String designation = _designationValue;
      String email = _emailValue;
      String remark = _remarkValue;
      String phone = _phoneValue;
      int country = CountryValue.id;
      int product = ProductSegmentValue.id;
      XFile? imageFile = _image;
      bool savedByApi = false;
      bool savedByApiwithNet = true;

      if(!netConected){
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            formSubmitting = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SuccessScreen()),
          );
        });
        await _saveDatatoFirebase(exbValue, remark, customerType, companyName, name, designation, email, phone, country, product, imageFile, savedByApi);


      }else{
        await _saveDatatoFirebase(exbValue, remark, customerType, companyName, name, designation, email, phone, country, product, imageFile, savedByApiwithNet);
        await _saveDatabyApi(exbValue, remark, customerType, companyName, name, designation, email, phone, country, product, imageFile);
      }

      setState(() {
        formSubmitting = false;
      });
    }
  }

  Widget renderError(prm, errorbool){
    if(errorbool){
      return Container(
        width: double.infinity,
        child: Text(prm, style: TextStyle(
          color: Colors.red,
        ),),
      );
    }else{
      return SizedBox();
    }

  }

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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black54, // Choose your desired color
                        width: 1.0, // Choose your desired width
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      DropdownButton<Exhibition>(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: ExhibitionValue,
                        onChanged: (Exhibition? value) {
                          setState(() {
                            ExhibitionValue = value!;
                          });
                          _validateAndSubmitForm();
                        },
                        items: Exhibitionlist.map<DropdownMenuItem<Exhibition>>((Exhibition exhibition) {
                          return DropdownMenuItem<Exhibition>(
                            value: exhibition,
                            child: Text(exhibition.title),
                          );
                        }).toList(),
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: ExhibitionIcon,
                        ),
                      ),

                    ],
                  ),
                ),
                renderError('Exibition is required', ExbErr),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black54, // Choose your desired color
                        width: 1.0, // Choose your desired width
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      DropdownButton<Customer>(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff000000)
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: CustomerTypeValue,
                        onChanged: (Customer? value) {
                          setState(() {
                            CustomerTypeValue = value!;
                          });
                          _validateAndSubmitForm();
                        },
                        items: CustomerTypelist.map<DropdownMenuItem<Customer>>((Customer customer) {
                          return DropdownMenuItem<Customer>(
                            value: customer,
                            child: Text(customer.title),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                renderError('Customer Type is required', customerErr),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    initialValue: _comapnyValue,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Company Name',
                      prefixIcon: Container(
                        padding: EdgeInsets.all(5),
                        width: 40, // Adjust width to increase size
                        height: 40, // Adjust height to increase size
                        child: CompanyIcon, // Your prefixIcon widget
                      ),
                      contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
                    onChanged: (value){
                      setState(() {
                        _comapnyValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    initialValue: _nameValue,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10),
                          width: 40, // Adjust width to increase size
                          height: 40, // Adjust height to increase size
                          child: UserIcon, // Your prefixIcon widget
                        ),
                        contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
                    onChanged: (value){
                      setState(() {
                        _nameValue = value;
                      });
                      _validateAndSubmitForm();
                    },
                  ),
                ),
                renderError('Name is required', NameErr),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    initialValue: _designationValue,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Designation',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(5),
                          width: 40, // Adjust width to increase size
                          height: 40, // Adjust height to increase size
                          child: DesignationIcon, // Your prefixIcon widget
                        ),
                        contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
                    onChanged: (value){
                      setState(() {
                        _designationValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    initialValue: _emailValue,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(5),
                          width: 40, // Adjust width to increase size
                          height: 40, // Adjust height to increase size
                          child: EmailIcon, // Your prefixIcon widget
                        ),
                        contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
                    onChanged: (value){
                      setState(() {
                        _emailValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    initialValue: _phoneValue,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Phone',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(5),
                          width: 40, // Adjust width to increase size
                          height: 40, // Adjust height to increase size
                          child: PhoneIcon, // Your prefixIcon widget
                        ),
                        contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
                    onChanged: (value){
                      setState(() {
                        _phoneValue = value;
                      });
                      _validateAndSubmitForm();
                    },
                  ),
                ),
                renderError('Phone No is required', PhoneErr),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black54, // Choose your desired color
                        width: 1.0, // Choose your desired width
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      DropdownButton<Country>(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: CountryValue,
                        onChanged: (Country? value) {
                          setState(() {
                            CountryValue = value!;
                          });
                        },
                        items: Countrylist.map<DropdownMenuItem<Country>>((Country country) {
                          return DropdownMenuItem<Country>(
                            value: country,
                            child: Text(country.name),
                          );
                        }).toList(),
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CountryIcon,
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black54, // Choose your desired color
                        width: 1.0, // Choose your desired width
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      DropdownButton<ProductSegment>(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: ProductSegmentValue,
                        onChanged: (ProductSegment? value) {
                          setState(() {
                            ProductSegmentValue = value!;
                          });
                          _validateAndSubmitForm();
                        },
                        items: ProductSegmentlist.map<DropdownMenuItem<ProductSegment>>((ProductSegment productSegment) {
                          return DropdownMenuItem<ProductSegment>(
                            value: productSegment,
                            child: Text(productSegment.title),
                          );
                        }).toList(),
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: ProductSegmentIcon,
                        ),
                      ),
                    ],
                  ),
                ),
                renderError('Product is required', ProductErr),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    maxLines: null,
                    initialValue: _remarkValue,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Remark',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(5),
                          width: 40, // Adjust width to increase size
                          height: 40, // Adjust height to increase size
                          child: RemarkIcon, // Your prefixIcon widget
                        ),
                        contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
                    onChanged: (value){
                      setState(() {
                        _remarkValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20,),
                internetConnected ? InkWell(
                  onTap: (){_pickImage();},
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black54, // Choose your desired color
                          width: 1.0, // Choose your desired width
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(45, 8, 0, 8),
                      child: Text(
                          _imageName ?? 'Select Image',
                        ),
                    ),
                  ),
                ) : SizedBox(),
                SizedBox(height: 30,),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Palette.themePallete,
                  textColor: Color(0xffFFFFFF),
                  padding: EdgeInsets.all(12),
                  onPressed: () {
                    if(!formSubmitting){
                    _SubmitForm();
                    }
                  },
                  child: Text(formSubmitting ? 'Submitting' : 'Submit',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
