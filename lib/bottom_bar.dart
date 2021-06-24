import 'package:flutter/material.dart';

class LiziBottomBar extends StatelessWidget {
  const LiziBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      child: Center(
        child: Text(
          'Authored By PonyCui',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
