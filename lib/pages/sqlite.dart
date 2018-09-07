import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:analyzer/file_system/file_system.dart';

class MySqlite extends StatefulWidget {
  final title;
  MySqlite(this.title);

  @override
  MySqliteState createState() => MySqliteState(title);
}

class MySqliteState extends State<MySqlite> {
  String title;
  MySqliteState(this.title);

  TextEditingController _userNameController = new TextEditingController();

  Future<String> get _dbPath async {
    //获取数据库存储目录 DocumentDirectory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "name.db");
    return path;
  }
  Future<Database> get _localFile async {
    //开启数据库 sql
    final path = await _dbPath;
    Database database= await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXIST user WHERE (id INTEGER PRIMARY KEY, name TEXT)");
    });
    return database;
  }

  Future<int> save(String name) async {
    //插入
    final db = await _localFile;
    return db.transaction((trx){
      trx.rawInsert("INSERT INTO user(name) VALUES('$name')");
    });
  }
  Future<List<Map>> get() async {
    //查询
    final db = await _localFile;
    List<Map> list = await db.rawQuery("SELECT * FROM user");
    return list;
  }



  @override
  Widget build(BuildContext context) {
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
                    child: Text('Sqlite存储')
                  ),
                  RaisedButton(
                    onPressed: () {
                      Future<List<Map>> userName = get();
                      userName.then((List<Map> userNames) {
                        Scaffold.of(context).showSnackBar(
                          new SnackBar(content: Text('数据获取成功:$userNames'), duration: Duration(seconds: 10))
                        );
                      });
                    },
                    color: Colors.green,
                    child: Text('Sqlite获取')
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