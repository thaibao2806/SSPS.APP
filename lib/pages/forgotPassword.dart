import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> dev
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/models/forgotPassword_request_model.dart';
import 'package:ssps_app/pages/loginPage.dart';
<<<<<<< HEAD
=======
import 'package:ssps_app/pages/otpPage.dart';
import 'package:ssps_app/pages/changePassword.dart';
>>>>>>> dev
import 'package:ssps_app/service/api_service.dart';

class forgotPassword extends StatefulWidget {
  forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {

  TextEditingController _emailController = TextEditingController();
  bool _isEmailEmpty = false;
  bool _isLoading = false;

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffA1F0FB),
              Color(0xffA1F0FB)
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 400),
            child: Container(
                height: 150, // Đặt chiều cao tùy ý tại đây
                width: double.infinity,
                decoration: BoxDecoration( // Đặt đường viền cho hình ảnh
                borderRadius: BorderRadius.circular(20), // Đặt bo góc cho hình ảnh
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Thêm padding 10px ở cả hai bên trái và phải
                        child: ClipRRect( // Để tránh bo góc vượt qua phần border
                          borderRadius: BorderRadius.circular(10),
                          child: const Image(
                            image: AssetImage('assets/images/forgot-password.png'),
                            fit: BoxFit.cover, // Đảm bảo hình ảnh vừa với kích thước container
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 400.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child:  Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18, top: 10),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Reset password',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: _emailController,
                    onChanged: (value) {
                      setState(() {
                        _isEmailEmpty = value.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      errorText: _isEmailEmpty ? "Please enter your email" : null,
                      suffixIcon: Icon(Icons.check,color: Colors.grey,),
                      label: Text('Email',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Color.fromARGB(255, 0, 0, 0),
                      ),)
                    ),
                  ),
                  const SizedBox(height: 25,),
                  GestureDetector(
                    onTap: () {
                      if (!_isLoading) { // Kiểm tra không phải đang trong quá trình loading
                        setState(() {
                          _isLoading = true; // Bắt đầu hiển thị vòng loading
                      });
                        if (_emailController.text.isEmpty) {
                          // Hiển thị thông báo nếu ô input rỗng
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter email.'),
                            ),
                          );
                        } else {
                          ForgotPasswordRequestModel model = ForgotPasswordRequestModel(email: _emailController.text!);
                          ApiService.fotgotPassword(model).then((response) => {
                            if(response.result) {
                              FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                "Email has been sent. Please check your email.",
                                "OK",
                                () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  loginPage()));
                                }
                              )
                            } else {
                              FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                response.msgDesc as String,
                                "OK",
                                () {
                                  Navigator.pop(context);
                                }
                              )
                            }
                          }).whenComplete(() {
                            setState(() {
                              _isLoading = false; // Tắt vòng loading khi hoàn thành xử lý API
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
                      }
                      },
                    child: Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff2E4DF2),
                            Color(0xff2E4DF2),
                          ]
                        ),
                      ),
                      child: Center(
                        child: _isLoading ? CircularProgressIndicator() : Text('Send email',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),),),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Back to ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        ),),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  loginPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6), // Thiết lập padding cho nút
                            margin: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Color(0xffF64B4B), // Màu nền cho nút
                              borderRadius: BorderRadius.circular(8), // Đặt bo tròn cho nút
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
      ],
    ));
  }
}
=======
  Widget build(BuildContext context)  {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffA1F0FB), Color(0xffA1F0FB)]),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 400),
                child: Container(
                  height: 150, // Đặt chiều cao tùy ý tại đây
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
                              20.0), // Thêm padding 10px ở cả hai bên trái và phải
                      child: ClipRRect(
                        // Để tránh bo góc vượt qua phần border
                        borderRadius: BorderRadius.circular(10),
                        child: const Image(
                          image:
                              AssetImage('assets/images/forgot-password.png'),
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
              padding: const EdgeInsets.only(top: 400.0),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset password',
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
                                ? "Please enter your email"
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
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          String email = _emailController.text;
                          if(!regex.hasMatch(email)) {
                            FormHelper.showSimpleAlertDialog(
                                                context,
                                                Config.appName,
                                                "Email invalid.",
                                                "OK", () {
                                              Navigator.pop(context);
                                            });
                          }
                          if (!_isLoading) {
                            setState(() {
                              _isLoading =
                                  true; 
                            });
                            if (_emailController.text.isEmpty) {
                              FormHelper.showSimpleAlertDialog(
                                                context,
                                                Config.appName,
                                                "Please enter email.",
                                                "OK", () {
                                              Navigator.pop(context);
                                            });
                            } else {
                              ForgotPasswordRequestModel model =
                                  ForgotPasswordRequestModel(
                                      email: _emailController.text!);
                              ApiService.fotgotPasswordOTP(model)
                                  .then((response) => {
                                        if (response.result)
                                          {

                                            prefs.setString("emailOTP",  _emailController.text!),
                                            FormHelper.showSimpleAlertDialog(
                                                context,
                                                Config.appName,
                                                "Email has been sent. Please check your email.",
                                                "OK", () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangePassword()));
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
                                      })
                                  .whenComplete(() {
                                setState(() {
                                  _isLoading =
                                      false; // Tắt vòng loading khi hoàn thành xử lý API
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
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 300,
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
                                    'Send email',
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
                              "Back to ",
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
                                        builder: (context) => loginPage()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6), // Thiết lập padding cho nút
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
          ],
        ));
  }
}
>>>>>>> dev
