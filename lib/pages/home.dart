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
