import 'package:flutter/material.dart';

class LiziAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1176, minHeight: 72),
        child: Row(
          children: [
            Container(
              height: 66,
              child: Image.asset('assets/logo.png'),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
