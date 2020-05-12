import 'package:flutter/material.dart';
// import 'package:todo_2/dbhelper.dart';

import 'dphelper.dart';

class Night extends StatefulWidget {
  @override
  _NightState createState() => _NightState();
}

class _NightState extends State<Night> {
  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  int i;
  var myitems = List();
  List<Widget> children = new List<Widget>();

  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.night: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated = true;
      errtext = "";
    });
  }

  Future<bool> query() async {
    myitems = [];
    children = [];

    var allrows = await dbhelper.querynight();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Container(
        // elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['nightTasks'],
              style: TextStyle(
                  fontSize: 18.0, fontFamily: "Raleway", color: Colors.white),
            ),
            onLongPress: () {
              dbhelper.deletedata(row['id']);
              setState(() {});
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val) {
                      todoedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            if (texteditingcontroller.text.isEmpty) {
                              setState(() {
                                errtext = "Can't Be Empty";
                                validated = false;
                              });
                            } else if (texteditingcontroller.text.length >
                                512) {
                              setState(() {
                                errtext = "Too may Chanracters";
                                validated = false;
                              });
                            } else {
                              addtodo();
                            }
                          },
                          color: Colors.green,
                          child: Text("ADD",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Raleway",
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text(
              "No Data",
            ),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  "No Task Avaliable",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 20.0,
                      color: Colors.white),
                ),
              ),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}
