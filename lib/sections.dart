import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mad_project/hadithList.dart';
import 'package:mad_project/pallets.dart';

class BookSection {
  final String name;
  final Map<String, String> sections;
  final Map<String, Map<String, dynamic>> sectionDetails;
  final List<Map<String, dynamic>> hadiths;

  BookSection({
    required this.name,
    required this.sections,
    required this.sectionDetails,
    required this.hadiths,
  });

  factory BookSection.fromJson(
      Map<String, dynamic> json, List<dynamic> hadiths) {
    return BookSection(
      name: json['name'],
      sections: Map<String, String>.from(json['sections']),
      sectionDetails:
          Map<String, Map<String, dynamic>>.from(json['section_details']),
      hadiths:
          hadiths.isNotEmpty ? List<Map<String, dynamic>>.from(hadiths) : [],
    );
  }
}

class Sections extends StatefulWidget {
  final String apiUrl;

  const Sections({Key? key, required this.apiUrl}) : super(key: key);

  @override
  _SectionsState createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  late Future<BookSection> futureBookSection;

  @override
  void initState() {
    super.initState();
    futureBookSection = fetchBookSection(widget.apiUrl);
  }

  Future<BookSection> fetchBookSection(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return BookSection.fromJson(data['metadata'], data['hadiths']);
      } else {
        throw Exception('Failed to load book section');
      }
    } catch (error) {
      throw Exception('Failed to load book section');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Sections'),
        backgroundColor: Pallete.backgroundColor,
        leading: BackButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
            }
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<BookSection>(
          future: futureBookSection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SectionListView(bookSection: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class SectionListView extends StatelessWidget {
  final BookSection bookSection;

  const SectionListView({Key? key, required this.bookSection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookSection.sections.length,
      itemBuilder: (context, index) {
        final sectionNumber = index + 1;
        final sectionName = bookSection.sections['$sectionNumber'] ?? '';
        final sectionDetails = bookSection.sectionDetails['$sectionNumber'];
        final hadiths = bookSection.hadiths;

        if (sectionDetails == null || sectionDetails.isEmpty) {
          return const SizedBox.shrink();
        }

        List<Map<String, dynamic>> sectionHadiths = hadiths
            .where((hadith) =>
                hadith['hadithnumber'] >=
                    sectionDetails['hadithnumber_first'] &&
                hadith['hadithnumber'] <= sectionDetails['hadithnumber_last'])
            .toList();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HadithList(hadiths: sectionHadiths),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'Section $sectionNumber',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    sectionName,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                children: <Widget>[
                  ListTile(
                    title: const Text('Details'),
                    subtitle: Text(
                      'First Hadith: ${sectionDetails['hadithnumber_first']} - Last Hadith: ${sectionDetails['hadithnumber_last']}',
                    ),
                  ),
                  ListTile(
                    title: const Text('Arabic Numbers'),
                    subtitle: Text(
                      'First Arabic: ${sectionDetails['arabicnumber_first']} - Last Arabic: ${sectionDetails['arabicnumber_last']}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
