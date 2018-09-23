import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class HomePage extends StatefulWidget{
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{

  String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;

  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  _documentPicker() async{
    String result;
    try{
      setState((){
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions:
        _checkByCustomExtension ? [_extensionController.text] : null,
        allowedUtiTypes: _iosPublicDataUTI ? null : [_utiController.text],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e){
      result = "Error: $e";
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });
  }

  _buildIOSParams() {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'iOS Params',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              Text(
                'Example app is configured to pick custom document type with extension ".mwfbak"',
                style: Theme.of(context).textTheme.body1,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Allow pick all documents("public.data" UTI will be used).',
                      softWrap: true,
                    ),
                  ),
                  Checkbox(
                    value: _iosPublicDataUTI,
                    onChanged: (value) {
                      setState(() {
                        _iosPublicDataUTI = value;
                      });
                    },
                  ),
                ],
              ),
              TextField(
                controller: _utiController,
                enabled: !_iosPublicDataUTI,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Uniform Type Identifier to pick:',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCommonParams() {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Common Params',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Check file by extension - if picked file does not have wantent extension - return "extension_mismatch" error',
                        softWrap: true,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: _checkByCustomExtension,
                    onChanged: (value) {
                      setState(() {
                        _checkByCustomExtension = value;
                      });
                    },
                  ),
                ],
              ),
              TextField(
                controller: _extensionController,
                enabled: _checkByCustomExtension,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'File extension to pick:',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("File Manager"),
      ),
      body: Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _button("Pick a File", _documentPicker),
              Text(
                'Picked file path:',
                style: Theme.of(context).textTheme.title,
              ),
              Text('$_path'),
              _pickFileInProgress ? CircularProgressIndicator() : Container(),
              _buildCommonParams(),
              Theme.of(context).platform == TargetPlatform.iOS
                ? _buildIOSParams()
                : Container(),
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