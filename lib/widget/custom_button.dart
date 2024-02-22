import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final void Function() onTap;
  final String text;

  const CustomButton({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
            style: ButtonStyle(
              // side: MaterialStateProperty.resolveWith<BorderSide>(
              //     (states) => BorderSide(color: Colors.white)),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Color(0xff2E4DF2)),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
              }),
              textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                  (states) => TextStyle(color: Colors.white)),
            ),
          ),
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(text,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          )
      )
    );
  }
}