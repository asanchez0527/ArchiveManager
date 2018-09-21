import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget{
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{
  final TextEditingController name = new TextEditingController();
  var nameField;
  var _image;

  Future _askUser() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      _image = image;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("File Manager"),
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _button("hello", _askUser),
              Image.file(_image),
              new TextField(
                controller: name,
                onChanged: (String newString){
                  setState(() {
                    nameField = name.text;
                  });
                },
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _button(String name, Function f){
    return MaterialButton(
      height: 100.0,
      child: Text (name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
      textColor: Colors.black,
      color: Colors.grey[100],
      onPressed: f,
    );
  }
}