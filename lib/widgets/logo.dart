import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String titulo;
  const Logo({required this.titulo, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/tag-logo.png'),
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(this.titulo, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
