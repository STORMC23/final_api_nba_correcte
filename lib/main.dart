import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'Afegir_jugador.dart'; 
import 'Detall_Cards.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina la marca de depuració
      title: 'NBA JSON', 
      theme: ThemeData(
        useMaterial3: true, 
        primarySwatch: Colors.blue, // Color principal
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Estils de text
        ),
      ),
      home: const MyHomePage(), // Pàgina inicial
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _items = []; // Llista d'articles (jugadors) a mostrar
  bool _isLoading = false; // Variable per controlar l'estat de càrrega

  // Funció per llegir el JSON local i obtenir la llista de jugadors
  Future<void> readJson() async {
    setState(() {
      _isLoading = true; // Activa l'estat de càrrega
    });

    // Llegeix el fitxer JSON des de l'arxiu 'nba.json'
    final String response = await rootBundle.loadString('assets/nba.json');
    final data = await json.decode(response); // Decodifica el contingut JSON

    setState(() {
      _items = data["items"]; // Assigna la llista d'articles al camp _items
      _isLoading = false; // Desactiva l'estat de càrrega
    });
  }

  // Funció per afegir un nou jugador
  Future<void> _addNewItem() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog( // Obre un quadre de diàleg per afegir un jugador
          onAdd: (String name, String imageUrl, double rating) { // Passa els valors del formulari
            setState(() {
              _items.add({
                "id": _items.length + 1, // Assigna un ID únic al nou jugador
                "name": name,
                "imatge": imageUrl,
                "rating": rating, // Guarda la puntuació
              });
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Color de la barra superior
        elevation: 8, // Altura de la barra
        title: const Text(
          'All-Star Salesians Sarria 2024-2025', // Títol de l'aplicació
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Centra el títol
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( // Gradient de fons
            colors: [Colors.blue.shade50, Colors.purple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Botó per carregar la llista de jugadors
            ElevatedButton(
              onPressed: readJson,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.deepPurple,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Obra el planter',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Mostra el carregant o la llista de jugadors
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  )
                : _items.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _items.length, // Nombre d'articles a mostrar
                          itemBuilder: (context, index) {
                            // Crea una targeta per a cada jugador
                            return Card(
                              key: ValueKey(_items[index]["id"]),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              elevation: 5,
                              shadowColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _items[index]["imatge"], // Imatge del jugador
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  _items[index]["name"], // Nom del jugador
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                // Mostra la puntuació del jugador com estrelles
                                subtitle: Row(
                                  children: List.generate(
                                    (_items[index]["rating"] ?? 10).toInt(),
                                    (i) => const Icon(Icons.star, size: 20, color: Colors.amber),
                                  ),
                                ),
                                onTap: () async {
                                  // Obre la pàgina de detalls del jugador i espera una resposta
                                  final updatedItem = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemDetailsPage(item: _items[index]),
                                    ),
                                  );

                                  if (updatedItem != null) {
                                    // Actualitza la llista amb la nova puntuació
                                    setState(() {
                                      _items[index] = updatedItem;
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No s’ha trobat cap dada. Obra el planter!!', // Missatge si no hi ha dades
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
            // Botó per afegir un nou jugador
            ElevatedButton.icon(
              icon: Icon(Icons.add), // Icona per afegir
              label: Text('Afegeix jugador'), // Text del botó
              onPressed: _addNewItem, // Acció al prem el botó
            )
          ],
        ),
      ),
    );
  }
}
