import 'db_helper.dart';

class Seed {
  static Future<void> carregarPalavras() async {
    final palavrasExistentes = await DBHelper.listarPalavras();

    if (palavrasExistentes.isEmpty) {
      List<Palavra> listaPalavras = [
        Palavra(palavra: 'Apple', significado: 'Maçã'),
        Palavra(palavra: 'Book', significado: 'Livro'),
        Palavra(palavra: 'Car', significado: 'Carro'),
        Palavra(palavra: 'Dog', significado: 'Cachorro'),
        Palavra(palavra: 'Elephant', significado: 'Elefante'),
        Palavra(palavra: 'Friend', significado: 'Amigo'),
        Palavra(palavra: 'House', significado: 'Casa'),
        Palavra(palavra: 'Love', significado: 'Amor'),
        Palavra(palavra: 'Music', significado: 'Música'),
        Palavra(palavra: 'Water', significado: 'Água'),
        Palavra(palavra: 'Water', significado: 'Água'),
        // 👉 Aqui você pode adicionar até 500 palavras depois.
      ];
      for (var palavra in listaPalavras) {
        await DBHelper.inserirPalavra(palavra);
      }

      print('Palavras inseridas com sucesso!');
    } else {
      print('Palavras já foram carregadas anteriormente.');
    }
  }
}


