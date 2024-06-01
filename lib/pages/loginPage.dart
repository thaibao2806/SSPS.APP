import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/models/login_request_model.dart';
import 'package:ssps_app/pages/forgotPassword.dart';
import 'package:ssps_app/pages/homePage.dart';
import 'package:ssps_app/pages/registerPage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/service/api_service.dart';

class loginPage extends StatefulWidget {
  loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool _isPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isLoading = false;

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
                          image: AssetImage('assets/images/signup.png'),
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
                          'Login',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                              suffixIcon: Icon(
                                Icons.check,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              )),
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
                              'Password',
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
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => forgotPassword()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xff281537),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              // Hiển thị thông báo nếu ô input rỗng
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please enter email and password.'),
                                ),
                              );
                              return;
                            }
                            if (!_isLoading) {
                              setState(() {
                                _isLoading = true;
                              });

                              LoginRequestModel model = LoginRequestModel(
                                  email: _emailController.text!,
                                  password: _passwordController.text!,
                                  deviceToken:
                                      'dz1Ee6tnTm6poFFo8tfu-V:APA91bFg1TZUsTfTi-IXzw8EPQN0avxpJOyC24fKnmNQ_HlUtSlRNglM1ro77NIS8X0ewr-evueH7hB5raZgDVlZNnsLSV7Iidrp5zbzFAYku3ZfvnZKI6F6Y6i9X2yfA23um4GSQUxm');
                              ApiService.login(model)
                                  .then((response) => {
                                        if (response.result)
                                          {
                                            Navigator.pop(context),
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportPage())),
                                          }
                                        else
                                          {
                                            FormHelper.showSimpleAlertDialog(
                                                context,
                                                Config.appName,
                                                response.msgDesc != null
                                                    ? response.msgDesc as String
                                                    : response.msgCode
                                                        as String,
                                                "OK", () {
                                              Navigator.pop(context);
                                            })
                                          }
                                      })
                                  .whenComplete(() {
                                setState(() {
                                  _isLoading = false;
                                });
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
                            child: Center(
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'LOGIN',
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
                                "Don't have account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage()));
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
                                    "Register",
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
