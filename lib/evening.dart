import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_2/todo.dart';

import 'new_todo.dart';

class Evening extends StatefulWidget {
  @override
  _EveningState createState() => _EveningState();
}

class _EveningState extends State<Evening> with SingleTickerProviderStateMixin {
  List<Todo> list = new List<Todo>();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'FlutterTodo',
            // key: Key('main-app-title'),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () => goToNewItemView(),
        ),
        body: list.isEmpty ? emptyList() : buildListView());
  }

  Widget emptyList() {
    return Center(
        child: Text(
      'No Task available',
      style: TextStyle(color: Colors.green, fontSize: 20),
    ));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return buildItem(list[index], index);
      },
    );
  }

  Widget buildItem(Todo item, index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.redAccent,
        ),
        child: Dismissible(
          key: Key('${item.hashCode}'),
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.redAccent,
            ),
            child: Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 12),
          ),
          onDismissed: (direction) => removeItem(item),
          direction: DismissDirection.startToEnd,
          child: buildListTile(item, index),
        ),
      ),
    );
  }

  Widget buildListTile(Todo item, int index) {
    print(item.completed);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green,
      ),
      child: ListTile(
        onTap: () => changeItemCompleteness(item),
        onLongPress: () => goToEditItemView(item),
        title: Text(
          item.title,
          key: Key('item-$index'),
          style: TextStyle(
              fontSize: item.completed ? 15 : 22,
              color: item.completed ? Colors.black : Colors.white,
              decoration: item.completed ? TextDecoration.lineThrough : null),
        ),
        trailing: Icon(
          item.completed ? Icons.check_box : Icons.check_box_outline_blank,
          key: Key('completed-icon-$index'),
        ),
      ),
    );
  }

  void goToNewItemView() {
    // Here we are pushing the new view into the Navigator stack. By using a
    // MaterialPageRoute we get standard behaviour of a Material app, which will
    // show a back button automatically for each platform on the left top corner
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView();
    })).then((title) {
      if (title != null) {
        addItem(Todo(title: title));
      }
    });
  }

  void addItem(Todo item) {
    // Insert an item into the top of our list, on index zero
    list.insert(0, item);
    saveData();
  }

  void changeItemCompleteness(Todo item) {
    setState(() {
      item.completed = !item.completed;
    });
    saveData();
  }

  void goToEditItemView(item) {
    // We re-use the NewTodoView and push it to the Navigator stack just like
    // before, but now we send the title of the item on the class constructor
    // and expect a new title to be returned so that we can edit the item
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
      setState(() {});
    });
  }

  void editItem(Todo item, String title) {
    item.title = title;
    saveData();
  }

  void removeItem(Todo item) {
    list.remove(item);
    if (list.isEmpty) {
      setState(() {});
    }
    saveData();
  }

  void loadData() {
    List<String> listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      list = listString.map((item) => Todo.fromMap(json.decode(item))).toList();
      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', stringList);
    setState(() {});
  }
}
