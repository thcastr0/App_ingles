import 'package:flutter/material.dart';
import 'db_helper.dart';


class AprendidasPage extends StatefulWidget {
  @override
  _AprendidasPageState createState() => _AprendidasPageState();
}

class _AprendidasPageState extends State<AprendidasPage> {
  List<Palavra> aprendidas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPalavrasAprendidas();
  }

  Future<void> carregarPalavrasAprendidas() async {
    final todas = await DBHelper.listarPalavras();
    final somenteAprendidas = todas.where((p) => p.aprendida).toList();

    setState(() {
      aprendidas = somenteAprendidas;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Palavras Aprendidas')),
      body: carregando
          ? Center(child: CircularProgressIndicator())
          : aprendidas.isEmpty
              ? Center(child: Text('Você ainda não marcou nenhuma palavra como aprendida.'))
              : ListView.builder(
                  itemCount: aprendidas.length,
                  itemBuilder: (context, index) {
                    final palavra = aprendidas[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(
                          palavra.palavra,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(palavra.significado),
                      ),
                    );
                  },
                ),
    );
  }
}
