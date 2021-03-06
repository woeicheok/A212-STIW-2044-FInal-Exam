import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mytutor2/model/subject.dart';
import 'package:mytutor2/views/BottomNavigation/Favourite.dart';
import 'package:mytutor2/views/BottomNavigation/Profile.dart';
import 'package:mytutor2/views/BottomNavigation/Subject_Screen.dart';
import 'package:mytutor2/views/BottomNavigation/Subscribe.dart';
import 'package:mytutor2/views/BottomNavigation/Tutor_Screen.dart';
import 'package:mytutor2/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor2/views/BottomNavigation/cartscreen.dart';
import '../constant.dart';
import 'loginscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  List<Subject> subjectlist = <Subject>[];
  String titlecenter = "Loading...";
  var numofpage, curpage = 1;
  int _currentIndex = 0;
  String maintitle = "MainPage";
  late double screenHeight, screenWidth, resWidth;
  bool shouldPop = true;
  String search = "";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      SubjectScreen(user: widget.user),
      TutorScreen(user: widget.user),
      const Subscribe(),
      const Favourite(),
      CartScreen(user: widget.user),
      ProfileScreen(
        user: widget.user,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure you want exit the app?'),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, exit(0));
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('My Tutor'), actions: []),
          drawer: Drawer(
              child: ListView(children: [
            _createDrawerItem(
                icon: Icons.settings, text: 'Settings', onTap: () {}),
            _createDrawerItem(
                icon: Icons.logout_outlined,
                text: 'Log Out',
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title:
                              const Text('Are you sure you want to log out?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const LoginScreen()));
                              },
                            ),
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                          ],
                        )))
          ])),
          body: tabchildren[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.subject_outlined,
                  ),
                  label: "Subject"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.man_outlined,
                  ),
                  label: "Tutor"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.subscriptions_outlined,
                  ),
                  label: "Subscribe"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  label: "Favourite"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  label: "Cart"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_box_outlined,
                  ),
                  label: "Profile"),
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Subject";
      }
      if (_currentIndex == 1) {
        maintitle = "Tutor";
      }
      if (_currentIndex == 2) {
        maintitle = "Subscribe";
      }
      if (_currentIndex == 3) {
        maintitle = "Favourite";
      }
      if (_currentIndex == 4) {
        maintitle = "Cart";
      }
      if (_currentIndex == 5) {
        maintitle = "Profile";
      }
    });
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(text))
        ],
      ),
      onTap: onTap,
    );
  }

  void _loadMyCart() {
    http.post(Uri.parse(CONSTANTS.server + "/mobile/php/load_mycart.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
  }
}
