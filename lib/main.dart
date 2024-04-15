import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seminário WS + SOA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResponderMensagemPage(),
                  ),
                );
              },
              child: Text('Responder Mensagem de Texto'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponderMensagemPage extends StatefulWidget {
  @override
  _ResponderMensagemPageState createState() => _ResponderMensagemPageState();
}

class _ResponderMensagemPageState extends State<ResponderMensagemPage> {
  TextEditingController _mensagemController = TextEditingController();

  Future<void> _enviarMensagem(BuildContext context) async {
    String mensagem = _mensagemController.text;
    String url = 'http://localhost:5001/servicos';

    Map<String, String> data = {
      'servico': 'mensagem',
      'mensagem': mensagem,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${json.decode(response.body)['mensagem']}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'Erro ao enviar mensagem';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar mensagem: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responder Mensagem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _mensagemController,
              decoration: InputDecoration(
                labelText: 'Digite sua mensagem',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _enviarMensagem(context),
              child: Text('Enviar Mensagem'),
            ),
          ],
        ),
      ),
    );
  }
}
