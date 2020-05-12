import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/provider/simple_hidden_drawer_provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                // child: FlareActor(
                //   'assets/girl.flr',
                //   alignment: Alignment.bottomRight,
                //   fit: BoxFit.contain,
                //   // animation: 'point2',
                // ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  elevation: 10,
                  splashColor: Colors.blue,
                  color: Colors.black87,
                  // shape: ShapeBorder(),

                  textColor: Colors.cyan,
                  onPressed: () {
                    SimpleHiddenDrawerProvider.of(context)
                        .setSelectedMenuPosition(0);
                  },
                  child: Text("Home"),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                    elevation: 10,
                    splashColor: Colors.blue,
                    color: Colors.black87,
                    // shape: ShapeBorder(),

                    textColor: Colors.cyan,
                    onPressed: () {
                      SimpleHiddenDrawerProvider.of(context)
                          .setSelectedMenuPosition(1);
                    },
                    child: Text("Menu 2")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
