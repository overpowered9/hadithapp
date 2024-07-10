import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoritesPage extends StatelessWidget {
  final List<String> favorites;

  const FavoritesPage({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                favorites[index],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: favorites[index]));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hadith text copied to clipboard')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}