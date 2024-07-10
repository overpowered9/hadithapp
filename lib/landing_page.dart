import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mad_project/favourite.dart';
import 'package:mad_project/home.dart';
import 'package:mad_project/login_page.dart';
import 'package:mad_project/pallets.dart';
import 'package:http/http.dart' as http;
import 'package:mad_project/prayerTime.dart';
import 'package:mad_project/resources/authFireBase.dart';
import 'package:mad_project/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithRandom {
  final List<Map<String, dynamic>> hadiths;

  HadithRandom({
    required this.hadiths,
  });

  factory HadithRandom.fromJson(List<dynamic> hadiths) {
    return HadithRandom(
      hadiths:
          hadiths.isNotEmpty ? List<Map<String, dynamic>>.from(hadiths) : [],
    );
  }
}

Future<HadithRandom> fetchHadithRandom() async {
  try {
    final response = await http.get(Uri.parse(
        "https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/eng-bukhari.json"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return HadithRandom.fromJson(data['hadiths']);
    } else {
      throw Exception('Failed to load book section');
    }
  } catch (error) {
    throw Exception('Failed to load book section');
  }
}

String? globalHadith;

class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _prayerTimeReminder = PrayerTimeReminder();
  bool _notificationsEnabled = false;
  String _username = '';
  String _email = '';
  List<String> _favorites = [];
  var hadith = '';
  var hijriDate = '';

  @override
  void initState() {
    _loadSwitchState();
    super.initState();
    fetchHadith();
    getHijriDate();
    fetchUserData();
    _initializePrayerTimeReminder();
  }
  _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = (prefs.getBool('notificationsEnabled') ?? false);
    });
  }
  _updateSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  fetchHadith() async {
    if (globalHadith == null) {
      var hadithData = await fetchHadithRandom();
      var random = Random();
      var randomHadith =
          hadithData.hadiths[random.nextInt(hadithData.hadiths.length)]['text'];
      setState(() {
        if (randomHadith != null) {
          hadith = randomHadith;
          globalHadith = randomHadith;
        } else {
          hadith = 'No hadith available';
          globalHadith = 'No hadith available';
        }
      });
    } else {
      setState(() {
        hadith = globalHadith!;
      });
    }
  }

  getHijriDate() {
    var hijriDate = HijriCalendar.now();
    setState(() {
      this.hijriDate = hijriDate.toString();
    });
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    try {
      DocumentSnapshot userData = await AuthMethods().getUserData(email);
      Map<String, dynamic>? data = userData.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          _username = data['username'] ?? '';
          _email = data['email'] ?? '';
          _favorites = List<String>.from(data['favorites'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _initializePrayerTimeReminder() async {
    await _prayerTimeReminder.initNotifications();
    await _prayerTimeReminder.setPrayerTimeReminders();
  }

 void _signOutUser() async {
  try {
    if (AuthMethods().getCurrentUser() != null) {
      await AuthMethods().signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('email');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  } catch (e) {
    print('Error signing out: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/home.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 220.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Today\'s Hijri Date: $hijriDate',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.teal.shade300],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hadith for you: ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$hadith.",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              accountName: Text(_username),
              accountEmail: Text(_email),
              currentAccountPicture: const CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                    'https://t3.ftcdn.net/jpg/00/64/67/80/360_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Salah Reminder'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _updateSwitchState(value);
                  });
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        FavoritesPage(favorites: _favorites)));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
            ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Sign Up'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SigninPage()));
                }),
                ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    onTap: () {
                      _signOutUser();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
