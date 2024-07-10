import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class QuranAyah {
  final int chapter;
  final int verse;
  final String text;

  QuranAyah({
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory QuranAyah.fromJson(Map<String, dynamic> json) {
    return QuranAyah(
      chapter: json['chapter'],
      verse: json['verse'],
      text: json['text'],
    );
  }
}

class QuranChapter extends StatefulWidget {
  final String apiUrl;
  const QuranChapter({Key? key, required this.apiUrl}) : super(key: key);

  @override
  State<QuranChapter> createState() => _QuranChapterState();
}

class _QuranChapterState extends State<QuranChapter> {
  late Future<List<QuranAyah>> futureAyahs;
   final Set<QuranAyah> favorites = Set<QuranAyah>();
   
  @override
  void initState() {
    super.initState();
    futureAyahs = fetchQuranData(widget.apiUrl);
  }

  Future<List<QuranAyah>> fetchQuranData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['quran'];
      final List<QuranAyah> ayahs = data.map((json) => QuranAyah.fromJson(json)).toList();
      return ayahs;
    } else {
      throw Exception('Failed to load Quran data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surahs'),
        backgroundColor: Colors.teal,
        leading: BackButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
             
            }
          },
        ), 
      ),
      body: FutureBuilder<List<QuranAyah>>(
        future: futureAyahs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final groupedAyahs = groupBy(snapshot.data!, (ayah) => ayah.chapter);

            return ListView.builder(
              itemCount: groupedAyahs.length,
              itemBuilder: (context, index) {
                final chapter = groupedAyahs.keys.elementAt(index);
                final chapterAyahs = groupedAyahs[chapter]!;

                return FadeInUp(
                  child: Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Surah $chapter',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal, 
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AyahsDetailPage(ayahs: chapterAyahs, chapter: chapter),
                          ),
                        );
                      },
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

class AyahsDetailPage extends StatelessWidget {
  final List<QuranAyah> ayahs;
  final int chapter;

  const AyahsDetailPage({Key? key, required this.ayahs, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter $chapter Ayahs'),
        backgroundColor: Colors.teal, 
      ),
      body: ListView.builder(
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final verse = ayahs[index].verse;
          final text = ayahs[index].text;

          if (index == ayahs.length - 1) {
            return Column(
              children: [
                ListTile(
                  title: Text('Verse $verse'),
                  subtitle: Text(text),
                ),
                const SizedBox(height: 20),
                Text('End of $chapter Surah'), 
              ],
            );
          } else {
            return ListTile(
              title: Text('Verse $verse'),
              subtitle: Text(text),
            );
          }
        },
      ),
    );
  }
}

Map<K, List<T>> groupBy<T, K>(Iterable<T> iterable, K Function(T) key) {
  final Map<K, List<T>> grouped = {};
  for (final element in iterable) {
    final K groupKey = key(element);
    grouped.putIfAbsent(groupKey, () => []).add(element);
  }
  return grouped;
}
