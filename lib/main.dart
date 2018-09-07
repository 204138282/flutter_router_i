import 'package:flutter/material.dart';
import 'package:flutter_routes_i/pages/page2.dart';
import 'package:flutter_routes_i/pages/future.dart';
import './pages/preference.dart';
import './pages/pathProvider.dart';
import './pages/sqlite.dart';


void main() => runApp(new MaterialApp(
      home: new MyApp(),
      routes: <String, WidgetBuilder>{
        '/page2': (BuildContext context) => new Page2('I am From Page1'),
      },
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final List<Item> list = [
    Item(Icons.router, '动态路由'),
    Item(Icons.time_to_leave, 'Future组件,异步任务'),
    Item(Icons.data_usage, 'Preferences存储'),
    Item(Icons.file_download, '文件存储(实现异常,后续修正!))'),
    Item(Icons.file_upload, 'Sqlite存储')
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('main')),
        body: new ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed('/page2');//[静态路由切换]
                    Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
                        (BuildContext context, Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                              
                      Widget temp;
                      if (index == 0) {
                        temp = new Page2(list[index].title);
                      } else if (index == 1) {
                        temp = new MyFuture(list[index].title);
                      } else if (index == 2) {
                        temp = new MyPreference(list[index].title);
                      } else if (index == 3) {
                        temp = new MyPathProvider(list[index].title);
                      } else if (index == 4) {
                        temp = new MySqlite(list[index].title);
                      }
                      return temp;
                    }));
                  },
                  child: new Item(list[index].iconData, list[index].title));
            },
            itemCount: list.length));
  }
}

class Item extends StatelessWidget {
  final IconData iconData;
  final String title;
  Item(this.iconData, this.title);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new ListTile(leading: Icon(iconData), title: new Text(title)),
        new Divider(color: Colors.grey, height: 1.0)
      ],
    );
  }
}
