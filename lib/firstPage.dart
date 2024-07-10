import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mad_project/languageScreen.dart';

class HadithName {
  final Map<String, dynamic> name;

  HadithName({required this.name});
}

Future<List<HadithName>> fetchNamesList() async {
  final response = await http.get(Uri.parse(
      "https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions.json"));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    List<HadithName> namesList = [];

    data.forEach((edition, nameData) {
      namesList.add(HadithName(name: nameData));
    });

    return namesList;
  } else {
    throw Exception("Failed to Load Data");
  }
}

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HadithRandomPageState createState() => _HadithRandomPageState();
}

class _HadithRandomPageState extends State<HadithPage> {
  late Future<List<HadithName>> futureName;
  @override
  void initState() {
    super.initState();
    futureName = fetchNamesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Select a Book of Hadith"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/books.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 200,
                  width: double.infinity,
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 15),
                FutureBuilder<List<HadithName>>(
                  future: futureName,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        options: CarouselOptions(
                          height: 200,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          pauseAutoPlayOnTouch: true,
                          enlargeCenterPage: true,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          final name = snapshot.data![index];
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LanguageScreen(
                                        hadithData: name.name['collection'])));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                      ),
                                      const Icon(
                                        Icons.book,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Center(
                                        child: Text(
                                          name.name['name'] as String,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          "No data in Snapshot because ${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
