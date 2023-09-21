import 'package:cadastra_livros/pages/formulario.dart';
import 'package:cadastra_livros/pages/sql_helper.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final tituloController = TextEditingController();
  final autorController = TextEditingController();

  List<Map<String, dynamic>> livros = [];
  bool carregando = true;

  void _atualizaLista() async {
    setState(() {
      carregando = true;
    });

    final livrosAtualizados = await SqlHelper.getList();

    setState(() {
      livros = livrosAtualizados;
      carregando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _atualizaLista();
  }

void _criarFormulario(int livroId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Formulario(livroId: livroId)),
    ).then((value) {
      if (value == true) {
        _atualizaLista();
      }
    });
  }

  Future<void> _deleteItem(Map<String, dynamic> livro) async {
    final confirmado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Deseja realmente excluir este livro?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      await SqlHelper.deleteItem(livro['id']);
      _atualizaLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros cadastrados'),
      ),
      body: livros.isEmpty
          ? const Center(child: Text('Nenhum livro cadastrado.'))
          : ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(livros[index]['titulo']),
                  subtitle: Text(livros[index]['autor']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _criarFormulario(livros[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(livros[index]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Formulario()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
