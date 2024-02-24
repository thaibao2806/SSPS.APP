
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ssps_app/components/my_drawer_header.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/models/register_request_model.dart';
import 'package:ssps_app/models/update_user_request_model.dart';
import 'package:ssps_app/pages/loginPage.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/utils/avatar.dart';
import 'package:ssps_app/widget/drawer_widget.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPage();
}



class _AccountPage extends State<AccountPage> {

  bool _isPasswordVisible = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  bool _isConfirmPasswordVisible = false;
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isFirstNameEmpty = false;
  bool _isLastNameEmpty = false;
  bool _isCodeEmpty = false;
  bool _isPhoneEmpty = false;
  bool _isSchoolEmpty = false;
  bool _isAddressEmpty = false;
  bool _isConfirmPasswordEmpty = false;
  String? firstName;
  String? lastName;
  bool isDataLoaded = false;

  @override
  void dispose() {
    super.dispose();
    _decodeToken();
  }

  @override
  void initState() {
    super.initState();
    _decodeToken();
    ApiService.getUserProfile().then((response) => {
      if(response.result) {
        setState(() {
          _firstNameController.text = response.data!.firstName;
          _lastNameController.text = response.data!.lastName;
          _codeController.text = response.data!.code;
          _phoneController.text = response.data!.phone;
          _emailController.text = response.data!.email;
          _schoolController.text = response.data!.school;
          _addressController.text = response.data!.location;
          _statusController.text = response.data!.status;
          print(response.data!.status);

        })
      } else {
        FormHelper.showSimpleAlertDialog(
          context,
          Config.appName,
          "Invalid Email/Password !",
          "OK",
          () {
            Navigator.pop(context);
          }
        )
      }
    });
  }

  _decodeToken() async {
    var token = (await SharedService.loginDetails()); // Assume this method retrieves the token
    String? accessToken = token?.data?.accessToken; // Access token might be null
      if (accessToken != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        firstName = decodedToken['firstName']; // Trích xuất firstName
        lastName = decodedToken['lastName']; // Trích xuất lastName
        setState(() {
          isDataLoaded = true;
        });
        if (firstName != null && lastName != null) {
          print("First name or last name is null");
        } else {
          print("First name or last name is null");
        }
      } else {
        print("Access token is null");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3498DB),
        elevation: 0,
        centerTitle: true,
        title: const Text("Account", style: TextStyle(color: Colors.white),),
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {
          SharedService.logout(context);
        }, icon: const Icon(Icons.logout), color: Colors.white,)],
      ),
      body: Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18, top: 10),
                  child: SingleChildScrollView(
                    reverse: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          height: 150,
                          child: AvatarWidget(firstName: firstName ?? '', lastName: lastName ?? '', width: 150, height: 150,fontSize: 60,onTap: () {},), 
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: TextField(
                                  controller: _firstNameController,
                                  onChanged: (value) {
                                    setState(() {
                                      _isFirstNameEmpty = value.isEmpty;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    errorText: _isFirstNameEmpty ? 'Please enter your first name' : null,
                                    // suffixIcon: Icon(Icons.check, color: Colors.grey,),
                                    labelText: 'First name',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: _lastNameController,
                                  onChanged: (value) {
                                    setState(() {
                                      _isLastNameEmpty = value.isEmpty;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    errorText: _isLastNameEmpty ? 'Please enter your last name' : null,
                                    // suffixIcon: Icon(Icons.check, color: Colors.grey,),
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: TextField(
                                  controller: _codeController,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCodeEmpty = value.isEmpty;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    errorText: _isCodeEmpty ? 'Please enter your code' : null,
                                    // suffixIcon: Icon(Icons.check, color: Colors.grey,),
                                    labelText: 'Code',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: _phoneController,
                                  onChanged: (value) {
                                    setState(() {
                                      _isPhoneEmpty = value.isEmpty;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    errorText: _isPhoneEmpty ? "Please enter your phone number" : null,
                                    // suffixIcon: Icon(Icons.check, color: Colors.grey,),
                                    labelText: 'Phone',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ), 
                        const SizedBox(height: 15),        
                        TextField(
                          controller: _schoolController,
                          onChanged: (value) {
                            setState(() {
                              _isSchoolEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            errorText: _isSchoolEmpty ? 'Please enter your school' : null,
                            // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('School',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 4, 4, 4),
                            ),)
                          ),
                        ),   
                        const SizedBox(height: 15),        
                        TextField(
                          controller: _emailController,
                          onChanged: (value) {
                            setState(() {
                              _isEmailEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            errorText: _isEmailEmpty ? 'Please enter your email' : null,
                            // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Email',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 4, 4, 4),
                            ),)
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _addressController,
                          onChanged: (value) {
                            setState(() {
                              _isAddressEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            errorText: _isAddressEmpty ? 'Please enter your address' : null,
                            // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Address',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color.fromARGB(255, 0, 0, 0),
                            ),)
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                           
                          UpdateUserRequestModel model = UpdateUserRequestModel(phone: _phoneController.text, firstName: _firstNameController.text, lastName: _lastNameController.text, school: _schoolController.text, location: _addressController.text);
                          ApiService.updateUserProfile(model).then((response) => {
                            if(response.result) {
                              FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                "Update successfull!!!",
                                "OK",
                                () {
                                  Navigator.pop(context);
                                }
                              )
                            } else {
                              FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                "Update failed!!",
                                "OK",
                                () {
                                  Navigator.pop(context);
                                }
                              )
                            }
                          });
                          // Thực hiện hành động khi cả hai ô input không rỗng
                          // Ví dụ: Thực hiện đăng nhập
                          // Nếu muốn điều hướng đến màn hình khác sau khi nhấn nút "Login", bạn có thể sử dụng Navigator
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => NextScreen()), // Thay NextScreen() bằng màn hình bạn muốn điều hướng đến
                          // );
                          },
                          child: Container(
                            height: 55,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff2E4DF2),
                                  Color(0xff2E4DF2),
                                ]
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Column(children: [
            const MyHeaderDrawer(),
            MyDrawerList(context),
          ]),
        )),
      ),
    );
  }
}