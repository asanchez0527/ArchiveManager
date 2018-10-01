import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget{
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{
  String _localFilePath = "";
  String status = "";
  bool _pickFileInProgress = false;

  Future<String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _localFile() async {
    String result;
    try{
      setState(() {
        _pickFileInProgress = true;
      });
      result = await FlutterDocumentPicker.openDocument();
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
        _localFilePath = result;
        status = "File chosen: " + basename(result);
      });
    }
  }

  _unzipFile() async {
    File fileToUnzip = File(_localFilePath);
    String result;
    final path = await _localPath;
    if (basename(fileToUnzip.path).contains("zip")) {
      try {
        var inputStream = await fileToUnzip.readAsBytes();
        Archive archive = new ZipDecoder().decodeBytes(inputStream);

        for (ArchiveFile file in archive) {
          String fileName = file.name;
          if (file.isFile) {
            List<int> data = file.content;
            new File(path + "/" + fileName)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            new Directory(path + '/' + fileName)
              ..create(recursive: true);
          }
          result = "Success";
        }
      } catch (e) {
        result = "Error: $e";
      } finally {
        setState(() {
          _localFilePath = result;
          status = result;
        });
      }
    }


  }

  @override
  void initState() {
    super.initState();
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
              new MaterialButton(
                  height: 100.0,
                  child: Text("Open File"),
                  onPressed: _localFile),
              Text("$status"),
              new MaterialButton(
                height: 100.0,
                child: Text("Extract"),
                onPressed: _unzipFile,
              ),
            ],
          ),
        )
      ),
    );
  }

}