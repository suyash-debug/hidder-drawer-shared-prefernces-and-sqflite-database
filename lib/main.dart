import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/provider/simple_hidden_drawer_provider.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';

import 'calendar.dart';
import 'firstscreen.dart';
import 'menu.dart';

void main() => runApp(MyApp());
// void main() {
//   initializeDateFormatting().then((_) => runApp(MyApp()));
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SimpleHiddenDrawer(
        menu: Menu(),
        contentCornerRadius: 50.0,
        screenSelectedBuilder: (position, controller) {
          Widget screenCurrent;

          switch (position) {
            case 0:
              screenCurrent = HomePage();
              break;
            case 1:
              screenCurrent = FirstScreen();
              break;
            // case 2 : screenCurrent = Screen3(); break;
          }

          return Scaffold(
            // backgroundColor: backgroundColorContent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                backgroundColor: Colors.black,
                title: Text('Always Focussed', style: TextStyle(fontSize: 20)),
                // elevation: 0,
                leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      controller.toggle();
                    }),
              ),
            ),
            body: screenCurrent,
          );
        },
      ),
    );
  }
}
