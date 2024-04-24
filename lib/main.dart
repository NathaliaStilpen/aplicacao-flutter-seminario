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
        '/responderMensagem': (context) => ResponderMensagemPage(),
        '/alterarArquivo': (context) => AlterarArquivoPage(),
        '/calcularFuncao': (context) => CalculadoraPage(),
        '/comprarCredito': (context) => ComprarCreditoPage(),
        '/compraSucesso': (context) => CompraSucessoPage(), // Nova tela para mostrar a compra bem-sucedida
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
                Navigator.pushNamed(context, '/responderMensagem');
              },
              child: Text('Responder Mensagem de Texto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/alterarArquivo');
              },
              child: Text('Alterar Arquivo de Texto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calcularFuncao');
              },
              child: Text('Calcular Função'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/comprarCredito');
              },
              child: Text('Comprar Crédito'),
            ),
          ],
        ),
      ),
    );
  }
}


class ComprarCreditoPage extends StatefulWidget {
  @override
  _ComprarCreditoPageState createState() => _ComprarCreditoPageState();
}

class _ComprarCreditoPageState extends State<ComprarCreditoPage> {
  TextEditingController _cpfController = TextEditingController();

  Future<void> _comprarCredito(BuildContext context, int horas) async {
    String cpf = _cpfController.text;
    String url = 'http://192.168.3.117:5001/servicos'; // URL do backend Flask

    // Dados da requisição
    Map<String, dynamic> data = {
      'servico': 'adicionar',
      'cpf': cpf,
      'creditos': horas, // Quantidade de horas a serem compradas
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
        var saldo = json.decode(response.body)['saldo'];
        // Redirecionar para a página de compra bem-sucedida com o valor do saldo
        Navigator.pushReplacementNamed(context, '/compraSucesso', arguments: saldo);
      } else {
        throw 'Erro ao realizar compra';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao realizar compra: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprar Crédito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(
                labelText: 'CPF',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Escolha a quantidade de horas:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _comprarCredito(context, 1), // Compra de 1 hora
              child: Text('1 hora'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _comprarCredito(context, 2), // Compra de 2 horas
              child: Text('2 horas'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _comprarCredito(context, 3), // Compra de 3 horas
              child: Text('3 horas'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _comprarCredito(context, 4), // Compra de 4 horas
              child: Text('4 horas'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _comprarCredito(context, 5), // Compra de 5 horas
              child: Text('5 horas'),
            ),
          ],
        ),
      ),
    );
  }
}

// Nova tela para mostrar a compra bem-sucedida
class CompraSucessoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saldo = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('Compra Realizada com Sucesso'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Compra realizada com sucesso!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Novo saldo: $saldo',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// As outras classes e funções permanecem iguais...


class ResponderMensagemPage extends StatefulWidget {
  @override
  _ResponderMensagemPageState createState() => _ResponderMensagemPageState();
}

class _ResponderMensagemPageState extends State<ResponderMensagemPage> {
  TextEditingController _mensagemController = TextEditingController();

  Future<void> _enviarMensagem(BuildContext context) async {
    String mensagem = _mensagemController.text;
    String url = 'http://192.168.3.117:5001/servicos';

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

class AlterarArquivoPage extends StatefulWidget {
  @override
  _AlterarArquivoPageState createState() => _AlterarArquivoPageState();
}

class _AlterarArquivoPageState extends State<AlterarArquivoPage> {
  TextEditingController _nomeArquivoController = TextEditingController();
  TextEditingController _textoArquivoController = TextEditingController();

  Future<void> _alterarArquivo(BuildContext context) async {
    String nomeArquivo = _nomeArquivoController.text;
    String textoArquivo = _textoArquivoController.text;
    String url = 'http://192.168.3.117:5001/servicos'; // Altere para o endereço correto

    Map<String, String> data = {
      'servico': 'arquivo',
      'nome_arquivo': nomeArquivo,
      'texto': textoArquivo,
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
        throw 'Erro ao alterar arquivo';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar arquivo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Arquivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeArquivoController,
              decoration: InputDecoration(
                labelText: 'Nome do Arquivo',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textoArquivoController,
              decoration: InputDecoration(
                labelText: 'Texto a ser Inserido',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _alterarArquivo(context),
              child: Text('Alterar Arquivo'),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  TextEditingController _numero1Controller = TextEditingController();
  TextEditingController _numero2Controller = TextEditingController();
  String _selectedOperation = "+"; // Operação padrão é a soma

  Future<void> _calcular() async {
    double num1 = double.tryParse(_numero1Controller.text) ?? 0.0;
    double num2 = double.tryParse(_numero2Controller.text) ?? 0.0;
    String operacao = _selectedOperation;

    String url = 'http://192.168.3.117:5001/servicos';
    Map<String, dynamic> data = {
      'servico': 'calculo',
      'numero1': num1,
      'numero2': num2,
      'operador': operacao,
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
        var resultado = json.decode(response.body)['resultado'];
        print(resultado);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Resultado"),
              content: Text("O resultado da operação é: $resultado"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        throw 'Erro ao calcular';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao calcular: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calcular Função'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _numero1Controller,
              decoration: InputDecoration(
                labelText: 'Número 1',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedOperation,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOperation = newValue!;
                });
              },
              items: <String>['+', '-', '*', '/']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _numero2Controller,
              decoration: InputDecoration(
                labelText: 'Número 2',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }
}
