import 'package:flutter/material.dart';
import 'db_helper.dart';


class TodasPalavrasPage extends StatefulWidget {
  @override
  _TodasPalavrasPageState createState() => _TodasPalavrasPageState();
}

class _TodasPalavrasPageState extends State<TodasPalavrasPage> {
  List<Palavra> palavras = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPalavras();
  }

  Future<void> carregarPalavras() async {
    final lista = await DBHelper.listarPalavras();
    setState(() {
      palavras = lista;
      carregando = false;
    });
  }

  Future<void> marcarComoAprendida(Palavra palavra) async {
    final palavraAtualizada = Palavra(
      id: palavra.id,
      palavra: palavra.palavra,
      significado: palavra.significado,
      aprendida: !palavra.aprendida,
    );

    await DBHelper.atualizarPalavra(palavraAtualizada);
    await carregarPalavras();
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return Scaffold(
        appBar: AppBar(title: Text('Todas as Palavras')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (palavras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Todas as Palavras')),
        body: Center(child: Text('Nenhuma palavra encontrada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Todas as Palavras')),
      body: ListView.builder(
        itemCount: palavras.length,
        itemBuilder: (context, index) {
          final palavra = palavras[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                palavra.palavra,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(palavra.significado),
              trailing: IconButton(
                icon: Icon(
                  palavra.aprendida ? Icons.check_circle : Icons.check_circle_outline,
                  color: palavra.aprendida ? Colors.green : Colors.grey,
                ),
                onPressed: () => marcarComoAprendida(palavra),
              ),
            ),
          );
        },
      ),
    );
  }
}
