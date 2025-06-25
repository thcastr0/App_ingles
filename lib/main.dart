import 'package:flutter/material.dart';
import 'seed.dart';
import 'db_helper.dart';
import 'tela_teste.dart';
import 'todas_palavras.dart';
import 'palavras_aprendidas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Seed.carregarPalavras();
  runApp(AppIngles());
}

class AppIngles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Inglês',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/aprendidas': (context) => AprendidasPage(),
        '/todas': (context) => TodasPalavrasPage(),
        '/teste': (context) => TelaTeste(),
        '/config': (context) => ConfiguracoesPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Palavra> palavrasDoDia = [];

  @override
  void initState() {
    super.initState();
    carregarPalavrasDoDia();
  }

  Future<void> carregarPalavrasDoDia() async {
    final todasPalavras = await DBHelper.listarPalavras();
    print('TOTAL DE PALAVRAS NO BANCO: ${todasPalavras.length}');
    final naoAprendidas = todasPalavras.where((p) => !p.aprendida).toList();
    final hoje = naoAprendidas.take(5).toList();

    setState(() {
      palavrasDoDia = hoje;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Palavras do Dia')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu')),
            ListTile(
              title: Text('Palavras Aprendidas'),
              onTap: () => Navigator.pushNamed(context, '/aprendidas'),
            ),
            ListTile(
              title: Text('Todas as Palavras'),
              onTap: () => Navigator.pushNamed(context, '/todas'),
            ),
            ListTile(
              title: Text('Teste'),
              onTap: () => Navigator.pushNamed(context, '/teste'),
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () => Navigator.pushNamed(context, '/config'),
            ),
          ],
        ),
      ),
      body: palavrasDoDia.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: palavrasDoDia.length,
              itemBuilder: (context, index) {
                final palavra = palavrasDoDia[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      palavra.palavra,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(palavra.significado),
                    trailing: IconButton(
                      icon: Icon(Icons.check_circle_outline),
                      color: Colors.green,
                      onPressed: () async {
                        Palavra atualizada = Palavra(
                          id: palavra.id,
                          palavra: palavra.palavra,
                          significado: palavra.significado,
                          aprendida: true,
                        );

                        await DBHelper.atualizarPalavra(atualizada);
                        await carregarPalavrasDoDia();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ConfiguracoesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Center(child: Text('Ajuste de preferências.')),
    );
  }
}
