// ignore_for_file: file_names

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor2/constant.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor2/model/subject.dart';
import 'package:mytutor2/model/tutor.dart';

import 'package:mytutor2/model/user.dart';

class SubjectScreen extends StatefulWidget {
  final User user;
  const SubjectScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subjectlist = <Subject>[];
  List<Tutor> tutorlist = <Tutor>[];
  String titlecenter = "Loading...";
  var numofpage, curpage = 1;
  late double screenHeight, screenWidth, resWidth;
  String search = "";
  var color;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search);
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
    return Scaffold(
      body: subjectlist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Subject Available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(subjectlist.length, (index) {
                        return InkWell(
                            splashColor: Colors.black,
                            onTap: () => {loadSubjectDetials(index)},
                            onLongPress: () => {},
                            child: Card(
                              child: Column(children: [
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                        "/mobile/assets/courses/" +
                                        subjectlist[index]
                                            .subjectId
                                            .toString() +
                                        '.jpg',
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error_outline),
                                  ),
                                ),
                                Flexible(
                                    flex: 0,
                                    child: Column(
                                      children: [
                                        Text(
                                          subjectlist[index]
                                              .subjectName
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    )),
                                Flexible(
                                    flex: 0,
                                    child: Column(
                                      children: [
                                        Text(
                                          'PRICE: RM' +
                                              subjectlist[index]
                                                  .subjectPrice
                                                  .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    title: const Text(
                                                        'Add to cart?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () {
                                                          _addtocartDialog(
                                                              index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text('No'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                      ),
                                                    ]));
                                      },
                                      icon:
                                          const Icon(Icons.add_shopping_cart)),
                                ),
                              ]),
                            ));
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.blueGrey;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadSubjects(index + 1, search)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {
          _loadSearchDialog();
        },
      ),
    );
  }

  void _loadSubjects(int pageno, String search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mobile/php/load_Subject.php"),
        body: {
          'pageno': pageno.toString(),
          'search': search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subject'] != null) {
          subjectlist = <Subject>[];
          extractdata['subject'].forEach((v) {
            subjectlist.add(Subject.fromJson(v));
          });
          titlecenter = subjectlist.length.toString() + "Subject Available";
        } else {
          titlecenter = "No Subject Available";
          subjectlist.clear();
        }
        setState(() {});
      } else {
        titlecenter = "No Subject Available";
        subjectlist.clear();
        setState(() {});
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void loadSubjectDetials(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mobile/assets/courses/" +
                      subjectlist[index].subjectId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subjectlist[index].subjectName.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Subject Name: " +
                      subjectlist[index].subjectName.toString()),
                  Text("Subject Description: \n" +
                      subjectlist[index].subjectDescription.toString()),
                  Text("Price: RM " +
                      double.parse(subjectlist[index].subjectPrice.toString())
                          .toStringAsFixed(2)),
                  Text("Tutor Id Taken for this subject: " +
                      subjectlist[index].tutorId.toString()),
                  Text("Subject Sessions: " +
                      subjectlist[index].subjectSessions.toString()),
                  Text("Subject Rating: " +
                      subjectlist[index].subjectRating.toString()),
                ])
              ],
            )),
            actions: [
              SizedBox(
                  width: screenWidth / 2,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Add to cart?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          _addtocartDialog(index);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                      ),
                                    ]));
                      },
                      child: const Text("Add to cart"))),
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _addtocartDialog(int index) {
    http.post(Uri.parse(CONSTANTS.server + "/mobile/php/insert_cart.php/"),
        body: {
          "email": widget.user.email.toString(),
          "subject_id": subjectlist[index].subjectId.toString(),
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
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
