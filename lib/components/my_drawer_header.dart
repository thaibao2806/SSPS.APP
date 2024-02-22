import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _decodeToken();
  }

  _decodeToken() async {
    var token = (await SharedService.loginDetails()); // Assume this method retrieves the token
    String? accessToken = token?.data?.accessToken; // Access token might be null
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
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // image: DecorationImage(
              //   // image: AssetImage('assets/images/profile.jpg'), // Chọn fit theo ý muốn của bạn (contain, cover, ...)
              // ),
            ),
          ),
          Text(fullName, style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(email, style: TextStyle(color: Colors.grey[200], fontSize: 14)),
        ],
      ),
    );
  }
}
