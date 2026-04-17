import 'dart:io';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/models/mensajes_response.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [
  ];
  bool _estaEscribiendo = false;

@override
void initState(){
  super.initState();
  chatService = Provider.of<ChatService>(context, listen: false);
  socketService = Provider.of<SocketService>(context, listen: false);
  authService = Provider.of<AuthService>(context, listen: false);

  socketService.socket.on('mensaje-personal', _escucharMensaje);

  _cargarHistorial(this.chatService.usuarioPara.uid);
}

void _cargarHistorial(String usuarioID) async {
  List<Mensaje> chat = await chatService.getChat(usuarioID);
  final history = chat.map((m)=> new ChatMessage(
    texto: m.mensaje,
    uid: m.de, 
    animationController: new AnimationController(vsync: this,duration: Duration(milliseconds: 0))..forward(),
    ));

setState(() {
  _messages.insertAll(0, history);
});
}


void _escucharMensaje(dynamic payload){
  ChatMessage message = ChatMessage(
    texto:payload['mensaje'],
    uid: payload['de'],
    animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
  );
  setState(() {
    _messages.insert(0, message);
  });
  message.animationController.forward();
}

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0, 2), style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1),
            Container(color: Colors.white, height: 50, child: _inputChat()),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('enviar'),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      texto: texto,
      uid: '123',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
    socketService.emit('mensaje-personal',{
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto,
    });
  }
  @override
  void dispose() {

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
