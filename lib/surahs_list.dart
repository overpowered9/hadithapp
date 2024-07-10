import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mad_project/QuranChapter.dart';
import 'package:animate_do/animate_do.dart';

class QuranEdition {
  final String name;
  final String author;
  final String language;
  final String direction;
  final String source;
  final String comments;
  final String link;
  final String linkMin;

  QuranEdition({
    required this.name,
    required this.author,
    required this.language,
    required this.direction,
    required this.source,
    required this.comments,
    required this.link,
    required this.linkMin,
  });

  factory QuranEdition.fromJson(Map<String, dynamic> json) {
    return QuranEdition(
      name: json['name'],
      author: json['author'],
      language: json['language'],
      direction: json['direction'],
      source: json['source'],
      comments: json['comments'],
      link: json['link'],
      linkMin: json['linkmin'],
    );
  }
}

Future<Map<String, QuranEdition>> fetchQuranEditions() async {
  final response = await http.get(Uri.parse('https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions.json'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final Map<String, QuranEdition> editions = {};

    data.forEach((key, value) {
      QuranEdition edition = QuranEdition.fromJson(value);
      if (edition.author == 'Quran Indopak' ||
          edition.author == 'Abdul Hye' ||
          edition.author == 'Abul A Ala Maududi' ||
          edition.name == 'hin-maulanaazizulha' ) {
        editions[key] = edition;
      }
    });

    return editions;
  } else {
    throw Exception('Failed to load Quran editions');
  }
}

class QuranBooks extends StatefulWidget {
  const QuranBooks({Key? key}) : super(key: key);

  @override
  State<QuranBooks> createState() => _QuranBooksState();
}

class _QuranBooksState extends State<QuranBooks> {
  late Future<Map<String, QuranEdition>> futureEditions;

  @override
  void initState() {
    super.initState();
    futureEditions = fetchQuranEditions();
  }

   @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Select the Language',)),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, QuranEdition>>(
        future: futureEditions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final key = snapshot.data!.keys.elementAt(index);
                final edition = snapshot.data![key];

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FadeInDown(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QuranChapter(
                              apiUrl: edition.link,
                            ),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                               Text(
                                edition!.language,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}