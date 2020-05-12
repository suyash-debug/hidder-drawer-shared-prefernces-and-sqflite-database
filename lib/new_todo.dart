import 'package:flutter/material.dart';
import 'package:todo_2/todo.dart';

class NewTodoView extends StatefulWidget {
  final Todo item;

  NewTodoView({this.item});

  @override
  _NewTodoViewState createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(
        text: widget.item != null ? widget.item.title : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.item != null ? 'Edit todo' : 'New todo',
          key: Key('new-item-title'),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xff050A30), Color(0xff050A10)])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                style: TextStyle(color: Colors.white),
                controller: titleController,
                autofocus: true,
                onSubmitted: (value) => submit(),
                decoration: InputDecoration(labelText: 'What todo'),
              ),
              SizedBox(
                height: 14.0,
              ),
              RaisedButton(
                color: Colors.green,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                onPressed: () => submit(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(titleController.text);
  }
}
