import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onTap;

  const AvatarWidget({
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String initials = '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getColorFromName(firstName, lastName),
          border: Border.all(
            color: const Color.fromARGB(198, 255, 255, 255),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String firstName, String lastName) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.deepOrange,
      Colors.cyan,
    ];
    int totalCharacters = firstName.length + lastName.length;
    int colorIndex = totalCharacters % colors.length;
    return colors[colorIndex];
  }
}
