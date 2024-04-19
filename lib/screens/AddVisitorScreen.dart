import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polytek/common/pallete.dart';
import 'package:polytek/screens/HomeScreen.dart';
import 'package:polytek/screens/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:polytek/common/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVisitorScreen extends StatefulWidget {
  final Map<String, dynamic>? visitorData;
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

  Future<void> firebaseData() async {
    print('started firebase');
    await FirebaseFirestore.instance
        .collection('exhibition-list')
        .get()
        .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {

              print('Title: ${doc['id']}, Subtitle: ${doc['title']}');
            });
          });
  }

  String _comapnyValue = '';
  String _nameValue = '';
  String _designationValue = '';
  String _phoneValue = '';
  String _emailValue = '';
  String _remarkValue = '';

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

    print('widget.visitorData');
    print(widget.visitorData);
    if(widget.visitorData != null){
      setState(() {
        _nameValue = widget.visitorData!['name'] ?? '';
        _comapnyValue = widget.visitorData!['org'] ?? '';
      });
    }
    // firebaseData();
    _getExhibitionFn();
    _getCustomerFn();
    _getCountryFn();
    _getProductSegmentFn();
  }

  Future<void> updateExhibitionToFirebase(Exhibitionlist) async {
  // the data structure for Exhibitionlist is like this
    print('Exhibitionlist ==');
    print(Exhibitionlist);
  }

  Future<void> _getExhibitionFn() async {
    var BaseUri = DataUtils.BaseUri;
    var request = http.Request('POST', Uri.parse('$BaseUri/getExhibitions'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      var exhibitionsData = jsonResponse['exhibition_list'] as List;

      var exhibitions = exhibitionsData.map((exhibitionData) => Exhibition(
        id: exhibitionData['id'],
        title: exhibitionData['title'],
      )).toList();
      // updateExhibitionToFirebase(Exhibitionlist);
      setState(() {
        Exhibitionlist = exhibitions;
        ExhibitionValue = exhibitions.first;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _getCustomerFn() async {
    var BaseUri = DataUtils.BaseUri;
    var request = http.Request('POST', Uri.parse('$BaseUri/getCustomerType'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      var customerData = jsonResponse['customer_type'] as List;
      customerData.insert(0, {'id': -1, 'title': 'Customer Type'});
      var customer = customerData.map((customerData) => Customer(
        id: customerData['id'],
        title: customerData['title'],
      )).toList();
      setState(() {
        CustomerTypelist = customer;
        CustomerTypeValue = customer.first;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _getCountryFn() async {
    var BaseUri = DataUtils.BaseUri;
    var request = http.Request('POST', Uri.parse('$BaseUri/getCountry'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      var countryData = jsonResponse['country_list'] as List;
      countryData.insert(0, {'id': -1, 'name': 'Country'});
      var country = countryData.map((countryData) => Country(
        id: countryData['id'],
        name: countryData['name'],
      )).toList();
      setState(() {
        Countrylist = country;
        CountryValue = country.first;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _getProductSegmentFn() async {
    var BaseUri = DataUtils.BaseUri;
    var request = http.Request('POST', Uri.parse('$BaseUri/getProducts'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var jsonResponse = json.decode(resp);
      var productData = jsonResponse['product_list'] as List;
      productData.insert(0, {'id': -1, 'name': 'Product Segment'});
      var product = productData.map((productData) => ProductSegment(
        id: productData['id'],
        title: productData['display_title'] ?? 'Product Segment',
      )).toList();
      setState(() {
        ProductSegmentlist = product;
        ProductSegmentValue = product.first;
      });
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


  Future<void> _SubmitForm() async {
    setState(() {
      formSubmitted = true;
    });
    _validateAndSubmitForm();
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
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('error .reasonPhrase');
        print(response.reasonPhrase);
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
    // return Container();
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
                InkWell(
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
                ),
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
