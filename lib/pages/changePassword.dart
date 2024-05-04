import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/models/changePasswordOTP_request_model.dart';
import 'package:ssps_app/models/changePassword_request_model.dart';
import 'package:ssps_app/models/login_request_model.dart';
import 'package:ssps_app/pages/forgotPassword.dart';
import 'package:ssps_app/pages/homePage.dart';
import 'package:ssps_app/pages/loginPage.dart';
import 'package:ssps_app/pages/registerPage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:ssps_app/service/shared_service.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isPasswordVisible = false;
  bool _isCurrentPasswordVisible = false;
  TextEditingController _currentController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isOTPEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isConfirmPasswordEmpty = false;
  String? id;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // resizeToAviodBottomPadding: false,
        body: Stack(
          children: [
            Container(
              // height: double.infinity,
              // width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffA1F0FB), Color(0xffA1F0FB)]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 42.0, bottom: 30),
                child: Container(
                  height: 300, // Đặt chiều cao tùy ý tại đây
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // Đặt đường viền cho hình ảnh
                    borderRadius:
                        BorderRadius.circular(20), // Đặt bo góc cho hình ảnh
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal:
                              29.0), // Thêm padding 10px ở cả hai bên trái và phải
                      child: ClipRRect(
                        // Để tránh bo góc vượt qua phần border
                        borderRadius: BorderRadius.circular(10),
                        child: const Image(
                          image: AssetImage('assets/images/change-password.png'),
                          fit: BoxFit
                              .cover, // Đảm bảo hình ảnh vừa với kích thước container
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 350.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                  child: SingleChildScrollView(
                    reverse: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _currentController,
                          // obscureText: !_isCurrentPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isOTPEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            // suffixIcon: IconButton(
                            //   icon: Icon(
                            //     _isCurrentPasswordVisible
                            //         ? Icons.visibility
                            //         : Icons.visibility_off,
                            //     color: Colors.grey,
                            //   ),
                            //   onPressed: () {
                            //     setState(() {
                            //       _isCurrentPasswordVisible =
                            //           !_isCurrentPasswordVisible;
                            //     });
                            //   },
                            // ),
                            label: const Text(
                              'OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            errorText: _isOTPEmpty
                                ? 'Please enter your OTP'
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isPasswordEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            label: const Text(
                              'New Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            errorText: _isPasswordEmpty
                                ? 'Please enter your password'
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _isConfirmPasswordEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            // suffixIcon: IconButton(
                            //   icon: Icon(
                            //     _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            //     color: Colors.grey,
                            //   ),
                            //   onPressed: () {
                            //     setState(() {
                            //       _isPasswordVisible = !_isPasswordVisible;
                            //     });
                            //   },
                            // ),
                            label: const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            errorText: _isConfirmPasswordEmpty
                                ? 'Please enter confirm password'
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            RegExp passwordRegex = new RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            String password = _passwordController.text;
                            SharedPreferences prefs = await SharedPreferences.getInstance();

                            if (!passwordRegex.hasMatch(password)) {
                              FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  "Password must have 8 digits including uppercase letters, lowercase letters, numbers and special characters",
                                  "OK", () {
                                Navigator.pop(context);
                              });
                              return;
                            }else 
                            if (_currentController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty) {
                              // Hiển thị thông báo nếu ô input rỗng
                              FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  "Please enter OTP, new password and confirm password.",
                                  "OK", () {
                                Navigator.pop(context);
                              });
                              return;
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  "Confirm password is incorrect",
                                  "OK", () {
                                Navigator.pop(context);
                              });
                              return;
                            } else {
                              String? email = prefs.getString("emailOTP");
                              ChangePasswordOtpRequestModel model =
                                  ChangePasswordOtpRequestModel(otp: _currentController.text, email: email, password: _passwordController.text, confirmPassword: _confirmPasswordController.text);
                              ApiService.changePasswordOTP(model)
                                  .then((response) => {
                                        print(response.msgDesc),
                                        if (response.result)
                                          {
                                            FormHelper.showSimpleAlertDialog(
                                                context,
                                                Config.appName,
                                                "Change password success!!!",
                                                "OK", () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          loginPage()));
                                            })
                                          }
                                        else
                                          {
                                            FormHelper.showSimpleAlertDialog(
                                                context,
                                                Config.appName,
                                                response.msgDesc as String,
                                                "OK", () {
                                              Navigator.pop(context);
                                            })
                                          
                                          }
                                      });

                            }
                          },
                          child: Container(
                            height: 55,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0xff2E4DF2),
                                Color(0xff2E4DF2),
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'Change password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Edit",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => forgotPassword()));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal:
                                          6), // Thiết lập padding cho nút
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF64B4B), // Màu nền cho nút
                                    borderRadius: BorderRadius.circular(
                                        8), // Đặt bo tròn cho nút
                                  ),
                                  child: const Text(
                                    "Email",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
