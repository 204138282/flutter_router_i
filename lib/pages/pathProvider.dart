import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:analyzer/file_system/file_system.dart';

class MyPathProvider extends StatefulWidget {
  final String title;
  MyPathProvider(this.title);

  @override
  MyPathProviderState createState() => MyPathProviderState(title);
  /**State<StatefulWidget> createState() {
    return new MyPathProviderState();
  }*/
}

class MyPathProviderState extends State<MyPathProvider> {
  String title;
  MyPathProviderState(this.title);

  TextEditingController _userNameController = new TextEditingController();

  //获取文件存储目录
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  //然后在本地建立文件
  //TODO: return new File('$path/nameFile.txt');  异常,后续修改.
  Future<File> get _localFile async {
    /*final path = await _localPath;
    return new File('$path/nameFile.txt');*/
  }
  Future<File> save(String name) async {
    final file = await _localFile;
    return file.writeAsStringSync(name);
  }


  @override
  Widget build(BuildContext context) {
    Future<String> get() async {
      final file = await _localFile;
      return file.readAsStringSync();
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text('$title')
      ),      
      body: new Center(
        child: Builder(builder: (BuildContext context){
          return new Column(
            children: <Widget>[
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top:10.0),
                  icon: Icon(Icons.perm_identity),
                  labelText: '请输入用户名',
                  helperText: '注册时使用的名字'
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      save(_userNameController.value.text.toString());
                      Scaffold.of(context).showSnackBar(
                        new SnackBar(content: Text('数据存储成功!'))
                      );
                    },
                    color: Colors.orange,
                    child: Text('文件存储')
                  ),
                  RaisedButton(
                    onPressed: () {
                      Future<String> uuserName = get();
                      uuserName.then((String uuserName) {
                        Scaffold.of(context).showSnackBar(
                          new SnackBar(content: Text('数据获取成功:$uuserName'), duration: Duration(seconds: 10))
                        );
                      });
                    },
                    color: Colors.green,
                    child: Text('文件获取')
                  )
                ]
              ),
            ]
          );
        })
      )
    );
  }
}