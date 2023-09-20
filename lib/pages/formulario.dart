import 'package:cadastra_livros/pages/home.dart';
import 'package:cadastra_livros/pages/sql_helper.dart';
import 'package:flutter/material.dart';

class Formulario extends StatefulWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final tituloController = TextEditingController();
  final autorController = TextEditingController();

  List<Map<String, dynamic>> livros = [];
  bool carregando = true;

void _gravar(BuildContext context, [int id = -1]) async {
    // pega os valores digitados no campo de texto
    String titulo = tituloController.text;
    String autor = autorController.text;
    // salva os registros
    int insertedId = await SqlHelper.gravar(titulo, autor, id);
   
    Navigator.of(context).pushReplacement( 
      MaterialPageRoute(
        builder: (context) => const HomeBody(),
      ),);
    if (insertedId > 0) {
      const snackBar = SnackBar(
        content: Text('Item salvo com Sucesso!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar um livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título: ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: autorController,
              decoration: const InputDecoration(
                labelText: 'Autor: ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () => _gravar(context),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
