import 'package:flutter/material.dart';
import 'package:mad_project/home.dart';
import 'package:mad_project/pallets.dart';
import 'package:mad_project/sections.dart';

class LanguageScreen extends StatelessWidget {
  final List<dynamic> hadithData;
  
  const LanguageScreen({Key? key, required this.hadithData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        title: const Text("Select a Language"),
      ),
      body: ListView.builder(
        itemCount: hadithData.length,
        itemBuilder: (context, index) {
          final hadith = hadithData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Center(
                child: Text(
                  hadith['language'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Sections(
                    apiUrl: hadith['link'],
                  ),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
