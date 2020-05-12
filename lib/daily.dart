import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:todo_2/evening.dart';
import 'package:todo_2/morning.dart';
import 'package:todo_2/night.dart';

import 'data.dart';
import 'firstscreen.dart';

class daily extends StatefulWidget {
  @override
  _dailyState createState() => _dailyState();
}

class _dailyState extends State<daily> {
  @override
  Widget build(BuildContext context) {
    double height;
    double width;
    height = MediaQuery.of(context).size.height / 2.6;
    width = MediaQuery.of(context).size.width;

    return Container(
      child: new ConstrainedBox(
        constraints: new BoxConstraints.loose(new Size(width, height)),
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                switch (days[index]) {
                  case "MORNING":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Morning()),
                    );
                    break;
                  case 'EVENING':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Evening()),
                    );
                    break;
                  case 'NIGHT':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Night()),
                    );
                    break;
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.tealAccent,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(images[index])),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          stops: [
                            0.1,
                            0.9
                          ],
                          colors: [
                            Colors.black.withOpacity(.8),
                            Colors.black.withOpacity(.1)
                          ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          days[index],
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplay: false,
          itemCount: 3,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
          viewportFraction: 0.7,
          scale: 0.6,
        ),
      ),
    );
  }
}
