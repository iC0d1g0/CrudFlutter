import 'package:crud/data/sql_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Crud De prueba Tomas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Map<String, dynamic>> _tabla = [];
  bool _isLoading = true;

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _sexo = TextEditingController();
  final TextEditingController _edad = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _correo = TextEditingController();

  void _refreshTabla() async {
    final data = await SqlHelper.getDatos();
    setState(() {
      _tabla = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTabla();
    print("cantidad de item... : ${_tabla.length}");
  }

  Future<void> _addItem() async {
    await SqlHelper.crearItem(_nombre.text, _sexo.text, _telefono.text,
        _correo.text, _edad.text, _direccion.text);
    _refreshTabla();
    print(".....Numero de elementos..: ${_tabla.length}");
  }

  Future<void> _updateItem(int id) async {
    await SqlHelper.actualizar(id, _nombre.text, _sexo.text, _telefono.text,
        _correo.text, _edad.text, _direccion.text);
    _refreshTabla();
  }

  Future<void> _borrar(int id) async {
    await SqlHelper.borrar(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Successfully deleted!! ")));
    _refreshTabla();
  }

  void _mostrarForm(int? id) {
    if (id != null) {
      final existeDatos = _tabla.firstWhere((element) => element['id'] == id);
      _nombre.text = existeDatos['nombre'];
      _edad.text = existeDatos['edad'];
      _sexo.text = existeDatos['sexo'];
      _telefono.text = existeDatos['telefono'];
      _direccion.text = existeDatos['direccion'];
      _correo.text = existeDatos['correo'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(
                  hintText: 'Nombre',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _sexo,
                decoration: const InputDecoration(
                  hintText: 'Sexo',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _correo,
                decoration: const InputDecoration(
                  hintText: 'Correo',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _edad,
                decoration: const InputDecoration(
                  hintText: 'Edad',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _direccion,
                decoration: const InputDecoration(
                  hintText: 'Direccion',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _telefono,
                decoration: const InputDecoration(
                  hintText: 'Telefono',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addItem();
                    }
                    if (id != null) {
                      await _updateItem(id);
                    }
                    _nombre.text = '';
                    _sexo.text = '';
                    _telefono.text = '';
                    _correo.text = '';
                    _edad.text = '';
                    _direccion.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Crear Nuevo' : 'Actualizar')),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _tabla.length,
          itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_tabla[index]['nombre'] +
                      " : " +
                      _tabla[index]['created_at']),
                  subtitle: Text(_tabla[index]['correo']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _mostrarForm(_tabla[index]['id']),
                        ),
                        IconButton(
                            onPressed: () => _borrar(_tabla[index]['id']),
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              )),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarForm(null),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
