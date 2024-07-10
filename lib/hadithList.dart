import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mad_project/pallets.dart';

class HadithList extends StatefulWidget {
  final List<Map<String, dynamic>> hadiths;

  const HadithList({Key? key, required this.hadiths}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HadithListState createState() => _HadithListState();
}

class _HadithListState extends State<HadithList> {
  late List<bool> favoriteStatus;

  @override
  void initState() {
    super.initState();
    favoriteStatus = List<bool>.filled(widget.hadiths.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadiths'),
        backgroundColor: Pallete.backgroundColor,
      ),
      body: ListView.builder(
        itemCount: widget.hadiths.length,
        itemBuilder: (context, index) {
          final hadith = widget.hadiths[index];
          if (hadith['text'].toString().trim().isEmpty) {
            return Container(); 
          }
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                'Hadith Number: ${hadith['hadithnumber']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Hadith Text: ${hadith['text']}.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.format_quote),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: hadith['text']));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hadith text copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: favoriteStatus[index] ? Colors.red : null,
                    ),
                    onPressed: () async {
                      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                      if (userId.isNotEmpty) {
                        await FirebaseFirestore.instance.collection('users').doc(userId).update({
                          'favorites': FieldValue.arrayUnion([hadith['text']]),
                        });
                        setState(() {
                          favoriteStatus[index] = true;
                        });
                      } else {
                        print('User not signed in');
                      }
                    },
                  ),
                  
                ],
              ),
              onTap: () {
                // Add your custom actions when tapping on a ListTile
              },
            ),
          );
        },
      ),
    );
  }
}