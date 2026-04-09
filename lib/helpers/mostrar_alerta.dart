import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
if (Platform.isAndroid) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
           style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              elevation: 5,
              backgroundColor: Colors.white,
            ),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}else{
  showCupertinoDialog(context: context, builder: (_){
    return CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    );
  });
}

  
}
