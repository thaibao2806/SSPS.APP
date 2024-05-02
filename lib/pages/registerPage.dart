import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/models/register_request_model.dart';
import 'package:ssps_app/pages/loginPage.dart';
import 'package:ssps_app/pages/otpPage.dart';
import 'package:ssps_app/service/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isFirstNameEmpty = false;
  bool _isLastNameEmpty = false;
  bool _isCodeEmpty = false;
  bool _isPhoneEmpty = false;
  bool _isSchoolEmpty = false;
  bool _isAddressEmpty = false;
  bool _isConfirmPasswordEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          //thanks for watching
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffA1F0FB), Color(0xffA1F0FB)]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 0.0, left: 22),
                // child: Text(
                //   'Create Your\nAccount',
                //   style: TextStyle(
                //       fontSize: 30,
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
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
                          "Register",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
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
                                    errorText: _isFirstNameEmpty
                                        ? 'Please enter your first name'
                                        : null,
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
                                    errorText: _isLastNameEmpty
                                        ? 'Please enter your last name'
                                        : null,
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
                                    errorText: _isCodeEmpty
                                        ? 'Please enter your code'
                                        : null,
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
                                    errorText: _isPhoneEmpty
                                        ? "Please enter your phone number"
                                        : null,
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
                              errorText: _isSchoolEmpty
                                  ? 'Please enter your school'
                                  : null,
                              // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                              label: Text(
                                'School',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 4, 4, 4),
                                ),
                              )),
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
                              errorText: _isEmailEmpty
                                  ? 'Please enter your email'
                                  : null,
                              // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 4, 4, 4),
                                ),
                              )),
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
                              errorText: _isAddressEmpty
                                  ? 'Please enter your address'
                                  : null,
                              // suffixIcon: Icon(Icons.check,color: Colors.grey,),
                              label: Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              )),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isPasswordEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            errorText: _isPasswordEmpty
                                ? 'Please enter your password'
                                : null,
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
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isConfirmPasswordEmpty = value.isEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            errorText: _isConfirmPasswordEmpty
                                ? 'Please enter your confirm password'
                                : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            label: const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("emailRegister", _emailController.text);
                            RegExp passwordRegex = new RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            String password = _passwordController.text;
                            if (!passwordRegex.hasMatch(password)) {
                              FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  "Password must have 8 digits including uppercase letters, lowercase letters, numbers and special characters",
                                  "OK", () {
                                Navigator.pop(context);
                              });
                              return;
                            }
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              // Hiển thị thông báo nếu ô input rỗng
                              FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  "Please enter email and password",
                                  "OK", () {
                                Navigator.pop(context);
                              });
                            } else {
                              RegisterRequestModel model = RegisterRequestModel(
                                  code: _codeController.text!,
                                  email: _emailController.text!,
                                  password: _passwordController.text!,
                                  firstName: _firstNameController.text!,
                                  lastName: _lastNameController.text!,
                                  phone: _phoneController.text!,
                                  role: "user",
                                  school: _schoolController.text!,
                                  location: _addressController.text!);
                              ApiService.register(model).then((response) => {
                                    if (response.result)
                                      {
                                        FormHelper.showSimpleAlertDialog(
                                            context,
                                            Config.appName,
                                            "Please check your email and enter the OTP code to complete registration",
                                            "OK", () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyVerify()));
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
                              // Thực hiện hành động khi cả hai ô input không rỗng
                              // Ví dụ: Thực hiện đăng nhập
                              // Nếu muốn điều hướng đến màn hình khác sau khi nhấn nút "Login", bạn có thể sử dụng Navigator
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => NextScreen()), // Thay NextScreen() bằng màn hình bạn muốn điều hướng đến
                              // );
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
                                'Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => loginPage()));
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
                                  child: Text(
                                    "Login",
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
