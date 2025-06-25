import 'package:flutter/material.dart';
import 'db_helper.dart';
class TelaTeste extends StatefulWidget {
  @override
  _TelaTesteState createState() => _TelaTesteState();
}

class _TelaTesteState extends State<TelaTeste> {
  List<Palavra> palavras = [];
  int perguntaAtual = 0;
  int pontuacao = 0;
  bool carregando = true;
  bool respondido = false;
  String mensagemFeedback = '';
  List<String> opcoes = [];

  @override
  void initState() {
    super.initState();
    carregarPalavrasDoBanco();
  }

  Future<void> carregarPalavrasDoBanco() async {
    final lista = await DBHelper.listarPalavras();

    setState(() {
      palavras = lista;
      carregando = false;
    });

    gerarOpcoes();
  }

  void gerarOpcoes() {
    if (palavras.isEmpty) return;

    final correta = palavras[perguntaAtual].significado;

    List<String> todasOpcoes = palavras.map((p) => (p as Palavra).significado).toList();

    todasOpcoes.remove(correta);
    todasOpcoes.shuffle();

    opcoes = [correta];
    opcoes.addAll(todasOpcoes.take(3));
    opcoes.shuffle();
  }

  void responder(String resposta) {
    if (respondido) return;

    setState(() {
      respondido = true;

      if (resposta == palavras[perguntaAtual].significado) {
        pontuacao++;
        mensagemFeedback = '✔️ Certo!';
      } else {
        mensagemFeedback = '❌ Errado! A resposta correta é "${palavras[perguntaAtual].significado}"';
      }
    });
  }

  void proximaPergunta() {
    if (perguntaAtual < palavras.length - 1) {
      setState(() {
        perguntaAtual++;
        respondido = false;
        mensagemFeedback = '';
        gerarOpcoes();
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Fim do Quiz!'),
          content: Text('Você acertou $pontuacao de ${palavras.length} perguntas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  perguntaAtual = 0;
                  pontuacao = 0;
                  respondido = false;
                  mensagemFeedback = '';
                  gerarOpcoes();
                });
              },
              child: Text('Reiniciar'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return Scaffold(
        appBar: AppBar(title: Text('Teste de Memorização')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (palavras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Teste de Memorização')),
        body: Center(child: Text('Nenhuma palavra encontrada no banco.')),
      );
    }

    final palavraAtual = palavras[perguntaAtual];

    return Scaffold(
      appBar: AppBar(title: Text('Teste de Memorização')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Traduza a palavra:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              palavraAtual.palavra,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ...opcoes.map((opcao) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: respondido ? null : () => responder(opcao),
                  child: Text(opcao, style: TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
            SizedBox(height: 24),
            if (mensagemFeedback.isNotEmpty)
              Text(
                mensagemFeedback,
                style: TextStyle(
                  fontSize: 20,
                  color: mensagemFeedback.startsWith('✔') ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            Spacer(),
            ElevatedButton(
              onPressed: respondido ? proximaPergunta : null,
              child: Text(perguntaAtual == palavras.length - 1 ? 'Finalizar' : 'Próxima'),
            ),
          ],
        ),
      ),
    );
  }
}
