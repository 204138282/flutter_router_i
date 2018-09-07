import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  final name;

  Page2(this.name);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('$name')),
      body: new Center(
        child: new GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text('$name', style: TextStyle(fontSize: 20.0))
        )
      ),
    );
  }
}
