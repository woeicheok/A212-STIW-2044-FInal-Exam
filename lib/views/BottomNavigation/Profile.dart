// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../model/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth;
    }
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text("Your Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      SizedBox(
          width: resWidth,
          child: Card(
            child: Row(
              children: [
                Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(widget.user.email.toString()),
                          Text('+60' + widget.user.phone.toString()),
                          Text(widget.user.address.toString()),
                        ],
                      ),
                    ))
              ],
            ),
          ))
    ])));
  }
}
