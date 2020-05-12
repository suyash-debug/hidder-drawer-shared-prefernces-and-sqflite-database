import 'package:flutter/material.dart';

class Morning extends StatefulWidget {
  @override
  _MorningState createState() => _MorningState();
}

class _MorningState extends State<Morning> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Item> items = [];

  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        decoration: new BoxDecoration(color: Colors.blueGrey),
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 32.0),
          child: new TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Please enter a task',
            ),
            onSubmitted: _onSubmit,
          ),
        ),
      );
    });
  }

  _onSubmit(String s) {
    if (s.isNotEmpty) {
      items.add(Item(s));
      _textEditingController.clear();
      setState(() {});
    }
  }

  _onDeleteItemPressed(item) {
    items.removeAt(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 5.0,
        backgroundColor: Colors.black,
        title: new Text('MORNING TARGET'),
      ),
      body: new Container(
        // decoration: BoxDecoration(color: Colors.teal),
        child: new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: ListTile(
                  title: Text(
                    '${items[index].title}',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () {
                      _onDeleteItemPressed(index);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onAddItemPressed,
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }
}

class Item {
  String title;

  Item(this.title);
}
