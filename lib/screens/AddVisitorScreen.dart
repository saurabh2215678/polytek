import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polytek/common/pallete.dart';
import 'package:polytek/screens/LoginScreen.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({Key? key}) : super(key: key);

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

const List<String> Exhibitionlist = <String>['Exhibition Name', 'MEFPU Expo 2024', 'MEFPU Expo 2023', 'MEFPU Expo 2022', 'MEFPU Expo 2021'];
String ExhibitionValue = Exhibitionlist.first;

const List<String> CustomerTypelist = <String>['Customer Type', 'Customer type 1', 'Customer type 2', 'Customer type 3', 'Customer type 4'];
String CustomerTypeValue = CustomerTypelist.first;

const List<String> ProductSegmentlist = <String>['Product Segment', 'Product Segment 1', 'Product Segment 2', 'Product Segment 3', 'Product Segment 4'];
String ProductSegmentValue = ProductSegmentlist.first;

class _AddVisitorScreenState extends State<AddVisitorScreen> {

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
                      DropdownButton(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000)
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: ExhibitionValue,
                        onChanged: (String? value) {
                          setState(() {
                            ExhibitionValue = value!;
                          });
                        },
                        items: Exhibitionlist.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
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
                      DropdownButton(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff000000)
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: CustomerTypeValue,
                        onChanged: (String? value) {
                          setState(() {
                            CustomerTypeValue = value!;
                          });
                        },
                        items: CustomerTypelist.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      // IgnorePointer(
                      //   ignoring: true,
                      //   child: Container(
                      //     width: 50,
                      //     height: 50,
                      //     child: ExhibitionIcon,
                      //   ),
                      // ),

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
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
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
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
                  ),
                ),
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
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Country',
                        prefixIcon: Container(
                          padding: EdgeInsets.all(5),
                          width: 40, // Adjust width to increase size
                          height: 40, // Adjust height to increase size
                          child: CountryIcon, // Your prefixIcon widget
                        ),
                        contentPadding: EdgeInsets.only(bottom: 8.0)
                    ),
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
                      DropdownButton(
                        padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff000000)
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: ProductSegmentValue,
                        onChanged: (String? value) {
                          setState(() {
                            ProductSegmentValue = value!;
                          });
                        },
                        items: ProductSegmentlist.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: Container(
                          width: 40,
                          height: 40,
                          child: ProductSegmentIcon,
                        ),
                      ),

                    ],
                  ),
                ),
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
                  ),
                ),
                SizedBox(height: 30,),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Palette.themePallete,
                  textColor: Color(0xffFFFFFF),
                  padding: EdgeInsets.all(12),
                  onPressed: () {},
                  child: Text('Submit',
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
