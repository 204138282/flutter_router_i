import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class MyPreference extends StatefulWidget {
  final String title;
  MyPreference(this.title);

  @override
  MyPreferenceState createState() => MyPreferenceState(title);
}

class MyPreferenceState extends State<MyPreference> {
  String title;
  MyPreferenceState(this.title);

  TextEditingController _userNameController = new TextEditingController();
  String userName = '';


  //存储
  save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', _userNameController.value.text.toString());
  }

  //获取
  Future<String> get() async {
    var uuserName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uuserName = prefs.getString('userName');
    return uuserName;
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
                      save();
                      Scaffold.of(context).showSnackBar(
                        new SnackBar(content: Text('数据存储成功!'))
                      );
                    },
                    color: Colors.orange,
                    child: Text('存储')
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
                    child: Text('获取')
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