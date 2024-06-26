import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:ssps_app/service/shared_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawer();
}

class _MyHeaderDrawer extends State<MyHeaderDrawer>  {
  String fullName = '';
  String email = '';
=======
import 'package:ssps_app/pages/accountPage.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/utils/avatar.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String fullName = '';
  String email = '';
  String? firstName;
  String? lastName;
>>>>>>> dev

  @override
  void initState() {
    super.initState();
    _decodeToken();
  }

  _decodeToken() async {
    var token = (await SharedService.loginDetails()); // Assume this method retrieves the token
    String? accessToken = token?.data?.accessToken; // Access token might be null
<<<<<<< HEAD
      if (accessToken != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        String? firstName = decodedToken['firstName']; // Trích xuất firstName
        String? lastName = decodedToken['lastName']; // Trích xuất lastName
        if (firstName != null && lastName != null) {
          setState(() {
            fullName = "$firstName $lastName";
            email = decodedToken["email"]; 
          });
        } else {
          print("First name or last name is null");
        }
      } else {
        print("Access token is null");
      }
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      width: double.infinity,
      height: 200,
=======
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      firstName = decodedToken['firstName'] ?? '';
      lastName = decodedToken['lastName'] ?? '';// Extract lastName
      if (firstName != null && lastName != null) {
        setState(() {
          fullName = "$firstName $lastName";
          email = decodedToken["email"];
        });
      } else {
        print("First name or last name is null");
      }
    } else {
      print("Access token is null");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff3498DB),
      width: double.infinity,
      height: 250,
>>>>>>> dev
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
<<<<<<< HEAD
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // image: DecorationImage(
              //   // image: AssetImage('assets/images/profile.jpg'), // Chọn fit theo ý muốn của bạn (contain, cover, ...)
              // ),
            ),
=======
            height: 100,
            child: AvatarWidget(firstName: firstName ?? '', lastName: lastName ?? '', width: 120, height: 120,fontSize: 40,
            onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AccountPage()));
                    },
            ), 
>>>>>>> dev
          ),
          Text(fullName, style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(email, style: TextStyle(color: Colors.grey[200], fontSize: 14)),
        ],
      ),
    );
  }
}
