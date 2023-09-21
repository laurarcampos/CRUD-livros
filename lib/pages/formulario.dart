  import 'package:flutter/material.dart';
  import 'package:cadastra_livros/pages/sql_helper.dart';

  class Formulario extends StatefulWidget {
    final int? livroId;

    const Formulario({Key? key, this.livroId}) : super(key: key);

    @override
    _FormularioState createState() => _FormularioState();
  }

  class _FormularioState extends State<Formulario> {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController autorController = TextEditingController();

    @override
    void initState() {
      super.initState();
      if (widget.livroId != null) {
        _editaLivro(widget.livroId!);
      }
    }

    void _editaLivro(int livroId) async {
      final livro = await SqlHelper.getlivro(livroId);
      if (livro.isNotEmpty) {
        tituloController.text = livro[0]['titulo'];
        autorController.text = livro[0]['autor'];
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.livroId != null ? 'Edite o livro' : 'Cadastre um livro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                controller: autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final titulo = tituloController.text;
                  final autor = autorController.text;

                  if (titulo.isNotEmpty && autor.isNotEmpty) {
                    if (widget.livroId != null) {
                      final id = await SqlHelper.gravar(titulo, autor, widget.livroId!);
                      if (id > 0) {
                        Navigator.pop(context, true);
                      }
                    } else {
                      final id = await SqlHelper.gravar(titulo, autor);
                      if (id > 0) {
                        Navigator.pop(context, true); 
                      }
                    }
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      );
    }
  }
