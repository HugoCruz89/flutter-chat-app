import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/label.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Logo(
                titulo: 'Messenger',
                key: Key('0'),
              ),

            _Form(),

            Label( 
              key: Key('3'),
              ruta: 'register',
              titulo: '¿No tienes cuenta?',
              subtitulo: 'Crear una ahora!',
            ),

            Text(
              'Términos y condiciones de uso',
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
  
  final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
            key: Key('1'),
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.emailAddress,
            textController: passCtrl,
            key: Key('2'),
            isPassword: true,
          ),
        BotonAzul(
          text: 'Ingrese',
          onPressed: authService.autenticando ? null : () async{
            FocusScope.of(context).unfocus();

           final loginOK = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
           if(loginOK){
            
             Navigator.pushReplacementNamed(context, 'usuarios');
           }
           else{
            mostrarAlerta(context, 'Login incorrecto', 'Por favor, intenta de nuevo');
           }
          },
          key: Key('12'),
        ),
        ],
      ),
    );
  }
}

