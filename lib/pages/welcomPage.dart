import 'package:flutter/material.dart';
import 'package:ssps_app/pages/loginPage.dart';
import 'package:ssps_app/pages/registerPage.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Stack(
       children:[ 
        Container(
        //  height: double.infinity,
        //  width: double.infinity,
         decoration: const BoxDecoration(
           gradient: LinearGradient(
             colors: [
               Color.fromARGB(255, 23, 63, 184),
              //  Color(0xff281537),
              Color(0xffA1F0FB)
             ]
           )
         ),
         child: Column(
           children: [
              Padding(
                padding: const EdgeInsets.only(top: 42.0),
                child: Container(
                  height: 250, // Đặt chiều cao tùy ý tại đây
                  width: double.infinity,
                  decoration: BoxDecoration( // Đặt đường viền cho hình ảnh
                    borderRadius: BorderRadius.circular(20), // Đặt bo góc cho hình ảnh
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 29.0), // Thêm padding 10px ở cả hai bên trái và phải
                    child: ClipRRect( // Để tránh bo góc vượt qua phần border
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: AssetImage('assets/images/home.jpg'),
                        fit: BoxFit.cover, // Đảm bảo hình ảnh vừa với kích thước container
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 89.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  height: 400,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 18, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Welcome to SSPS',style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>  loginPage()));
                          },
                          child: Container(
                            height: 60,
                            width: 320,
                            decoration: BoxDecoration(
                              color: Color(0xff94A5FB),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Màu shadow
                                  spreadRadius: 2, // Bán kính mở rộng của shadow
                                  blurRadius: 3, // Độ mờ của shadow
                                  offset: Offset(0, 3), // Vị trí của shadow
                                ),
                              ],
                            ),
                            child: const Center(child: Text('Login',style: TextStyle(
                                fontSize:30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),),),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()));
                          },
                          child: Container(
                            height: 60,
                            width: 320,
                            decoration: BoxDecoration(
                              color: Color(0xff2E4DF2),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Màu shadow
                                  spreadRadius: 2, // Bán kính mở rộng của shadow
                                  blurRadius: 3, // Độ mờ của shadow
                                  offset: Offset(0, 3), // Vị trí của shadow
                                ),
                              ],
                            ),
                            child: const Center(child: Text('Register',style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),),),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              )
       
            //  const SizedBox(
            //    height: 100,
            //  ),
            //  const Text('Welcome to SSPS',style: TextStyle(
            //    fontSize: 30,
            //    color: Colors.white
            //  ),),
            // const SizedBox(height: 30,),
            // GestureDetector(
            //   onTap: (){
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) =>  loginPage()));
            //   },
            //   child: Container(
            //     height: 53,
            //     width: 320,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30),
            //       border: Border.all(color: Colors.white),
            //     ),
            //     child: const Center(child: Text('SIGN IN',style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Color(0xff94A5FB)
            //     ),),),
            //   ),
            // ),
            //  const SizedBox(height: 30,),
            //  GestureDetector(
            //    onTap: (){
            //      Navigator.push(context,
            //          MaterialPageRoute(builder: (context) => const RegisterPage()));
            //    },
            //    child: Container(
            //      height: 53,
            //      width: 320,
            //      decoration: BoxDecoration(
            //        color: Colors.white,
            //        borderRadius: BorderRadius.circular(30),
            //        border: Border.all(color: Colors.white),
            //      ),
            //      child: const Center(child: Text('SIGN UP',style: TextStyle(
            //          fontSize: 20,
            //          fontWeight: FontWeight.bold,
            //          color: Color(0xff2E4DF2)
            //      ),),),
            //    ),
            //  ),
            //  const Spacer(),
            // //  const Text('Login with Social Media',style: TextStyle(
            // //      fontSize: 17,
            // //      color: Colors.white
            // //  ),),//
            // const SizedBox(height: 12,),
            //  const Image(image: AssetImage('assets/social.png'))
            ]
         ),
       ),
       ]
     ),

    );
    
  }
}