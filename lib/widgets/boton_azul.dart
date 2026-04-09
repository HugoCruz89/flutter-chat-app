import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String text;
  final  onPressed;


  const BotonAzul({
    required Key key,
    required this.text,
    required this.onPressed
    }):super(key: key);

  @override
  Widget build(BuildContext context) {
   return   ElevatedButton(
    
            onPressed: this.onPressed,
            
            style: ElevatedButton.styleFrom(
              // Styling is now handled in the 'style' property
              backgroundColor: Colors.blue,
              elevation: 2,
              fixedSize: Size.fromWidth(double.infinity)// Size(double.infinity, 55)
            ),
            child: Text(this.text, style: TextStyle(color: Colors.white,fontSize: 15 )),
          );
  }
}