import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  final Function(String name, String imageUrl, double rating) onAdd;

  const AddItemDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController nameController = TextEditingController(); 
  final TextEditingController imageController = TextEditingController(); 
  double rating = 5.0; 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Afegeix una nou jugador'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Redueix la mida del diàleg per no ocupar tot l'espai
          children: [
            // Camp per introduir el nom del jugador
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom', // Etiqueta per al camp de text
              ),
            ),
            // Camp per introduir l'URL de la imatge
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'URL de la imatge', // Etiqueta per a la URL de la imatge
              ),
            ),
            const SizedBox(height: 20), // Espai entre elements
            // Mostra el valor actual de la puntuació
            Text('Estrelles: ${rating.toInt()}'),
            // Slider per modificar la puntuació del jugador
            Slider(
              value: rating,
              min: 0, // Valor mínim
              max: 10, // Valor màxim
              divisions: 10, // Divisions del Slider
              label: rating.toInt().toString(), // Etiqueta de la puntuació actual
              onChanged: (newRating) {
                setState(() {
                  rating = newRating; // Actualitza la puntuació quan el Slider es mou
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        // Botó per cancel·lar i tancar el diàleg
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tanca el diàleg sense fer res
          },
          child: const Text('Cancel·la'),
        ),
        // Botó per afegir el jugador amb les dades introduïdes
        ElevatedButton(
          onPressed: () {
            // Si el camp de nom no està buit
            if (nameController.text.isNotEmpty) {
              String imageUrl = imageController.text.trim(); // Obtenim la URL de la imatge

              // Comprovem si la URL és vàlida
              Uri? uri = Uri.tryParse(imageUrl);
              // Si la URL no és vàlida, utilitzem una imatge per defecte
              if (uri == null || !uri.hasAbsolutePath) {
                imageUrl =
                    "https://cdn.pixabay.com/photo/2014/03/25/15/19/cross-296507_960_720.png"; // Imatge predeterminada
              }

              // Cridem la funció passada com a paràmetre per afegir el jugador
              widget.onAdd(
                nameController.text.trim(), // Nom del jugador
                imageUrl, // URL de la imatge
                rating, // Puntuació del jugador
              );
              Navigator.of(context).pop(); // Tanca el diàleg després d'afegir el jugador
            }
          },
          child: const Text('Afegeix'), // Text del botó
        ),
      ],
    );
  }
}
