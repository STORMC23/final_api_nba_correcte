import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  final Map item; // Rebi un mapa d'item com a paràmetre (informació del jugador)

  const ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late double rating; // Inicialitza la variable de la puntuació

  @override
  void initState() {
    super.initState();
    // Inicialitza la puntuació amb el valor de l'item o amb 10 com a valor per defecte
    rating = widget.item["rating"]?.toDouble() ?? 10.0;
  }

  @override
  Widget build(BuildContext context) {
    // Obtenim els valors de l'item, amb valors per defecte si són null
    String name = widget.item["name"] ?? "Unknown Name"; // Nom del jugador
    String imageUrl = widget.item["imatge"] ?? "https://via.placeholder.com/150"; // Imatge per defecte si és null

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Color de la barra superior
        title: Text(
          name, // Nom del jugador a la barra superior
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), // Màrgenes del cos de la pàgina
        child: Column(
          children: [
            // Imatge circular del jugador
            ClipRRect(
              borderRadius: BorderRadius.circular(75), // Fa la imatge circular
              child: Image.network(
                imageUrl, // URL de la imatge del jugador
                width: 150, // Mida de la imatge
                height: 150,
                fit: BoxFit.cover, // Assegura que la imatge es redimensioni bé dins del cercle
              ),
            ),
            const SizedBox(height: 20),

            // Nom del jugador
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Puntuació del jugador
            Text(
              "Rating: ${rating.toStringAsFixed(1)}/10", // Mostra la puntuació amb una casa decimal
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // Controlador Slider per canviar la puntuació
            Slider(
              value: rating,
              min: 0, // Valor mínim
              max: 10, // Valor màxim
              divisions: 10, // Divisions per a l'escala
              label: rating.toStringAsFixed(1), // Etiqueta amb la puntuació
              onChanged: (newRating) {
                setState(() {
                  rating = newRating; // Actualitza la puntuació quan es canvia el valor del slider
                });
              },
            ),
            const SizedBox(height: 20),

            const Spacer(), // Empenya els botons cap a la part inferior
            // Fil de botons: Desar i Tornar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espai entre els botons
              children: [
                // Botó per desar els canvis i tornar a la pantalla anterior
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Retorna l'item actualitzat amb la nova puntuació a la pantalla anterior
                      Navigator.pop(context, {
                        ...widget.item, // Afegeix les dades existents de l'item
                        "rating": rating, // Inclou la puntuació actualitzada
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Color del botó
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Màrgenes del botó
                    ),
                    child: const Text(
                      "Guardar", // Text del botó
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
