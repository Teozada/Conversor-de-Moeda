import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance?format=json&key=2a54a92f";

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final btcController = TextEditingController();
  final bldController = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;
  double boludinhos;

  void _clearAll() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
    btcController.text = '';
    bldController.text = '';
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    btcController.text = (real / bitcoin).toStringAsFixed(2);
    bldController.text = (real / boludinhos).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    btcController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(2);
    bldController.text = (dolar * this.dolar / boludinhos).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    btcController.text = (euro * this.euro / bitcoin).toStringAsFixed(2);
    bldController.text = (euro * this.euro / boludinhos).toStringAsFixed(2);
  }

  void _btcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double biticoin = double.parse(text);
    realController.text = (biticoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (biticoin * this.bitcoin / dolar).toStringAsFixed(2);
    euroController.text = (biticoin * this.bitcoin / euro).toStringAsFixed(2);
    bldController.text =
        (biticoin * this.bitcoin / boludinhos).toStringAsFixed(2);
  }

  void _bldChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bld = double.parse(text);
    realController.text = (bld * this.boludinhos).toStringAsFixed(2);
    dolarController.text = (bld * this.boludinhos / dolar).toStringAsFixed(2);
    euroController.text = (bld * this.boludinhos / euro).toStringAsFixed(2);
    btcController.text = (bld * this.boludinhos / bitcoin).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1c1c1c),
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando Dados...',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro ao Carregar os Dados',
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              } else {
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                bitcoin = snapshot.data['results']['currencies']['BTC']['buy'];
                boludinhos =
                    snapshot.data['results']['currencies']['ARS']['buy'];
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 100.0, color: Colors.amber),
                        Divider(),
                        buildTextField(
                            'Reais', 'R\$', realController, _realChanged),
                        Divider(),
                        buildTextField(
                            'Dólares', 'US\$', dolarController, _dolarChanged),
                        Divider(),
                        buildTextField(
                            'Euros', '€', euroController, _euroChanged),
                        Divider(),
                        buildTextField(
                            'Bitcoin', '฿', btcController, _btcChanged),
                        Divider(),
                        buildTextField(
                            'Boludinhos', '\$', bldController, _bldChanged),
                      ],
                    ));
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Colors.amber, fontSize: 20.0)),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
