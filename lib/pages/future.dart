import 'package:flutter/material.dart';
import 'dart:async';

class MyFuture extends StatefulWidget {
  final String name;
  MyFuture(this.name);

  @override
  /*
   *  MARK: 2种初始化方法(一))
  State<StatefulWidget> createState() {
    return new MyFutureState(name);
  }
  */

  /*
   *  MARK: 2种初始化方法(二))
   */
  MyFutureState createState() => new MyFutureState(name);
}

class MyFutureState extends State<MyFuture> {
  String name;
  MyFutureState(this.name);

  /*
   * 检验Future组件异步请求
   * 1. 和朋友进入了一家餐馆
   * 2. 我们的菜来了，我要开始吃饭了
   * 3. 我们朋友聊起家常
   * 4. 等了好好久了，我还是玩会手机吧
   *  从逻辑来看我们确实是先进入了餐馆，然后等待菜来，等的期间开始了聊天和玩手机。但是
   因为Dart是单线程的所以无论你等待饭来的时间多长，在这个操作没有完成之前他都不会去执行
   下面的操作，这样就不美好了啊，我在等吃饭的时间内什么也做不了了啊。
   *  这就是非异步操作引起的问题。在Flutter要想解决此问题可以借助于 Future
   */
  enterRestaurant() {
    return [{'thing':'①-和朋友进入了一家餐馆"'}];
  }

  String waitForDinner() {
    return "②-我们的菜来了，我要开始吃饭了";
  }

  String startChat() {
    return "③-我们朋友聊起家常";
  }

  String playPhone() {
    return "④-等了好好久了，我还是玩会手机吧";
  }
  
  @override
  void initState() {
    super.initState();
    
    print(enterRestaurant()); //执行-①
    Future<String> waitDinnerFuture = new Future(waitForDinner); //执行-②
    waitDinnerFuture.then((value) {
      print(value);
    });
    print(startChat()); //执行-③
    print(playPhone()); //执行-④
    /*
      - 打印结果:
      flutter: ①-和朋友进入了一家餐馆
      flutter: ③-我们朋友聊起家常
      flutter: ④-等了好好久了，我还是玩会手机吧
      flutter: ②-我们的菜来了，我要开始吃饭了
     */
  }

void asyncdo() {
  print("多异步执行完成!");

  //(!!!!以下内容暂无效果,后续优化~ ~ ~ ~ ~ ~)
  //按顺序执行
  Future enterRestaurantFuture() {
    return new Future(enterRestaurant);
  }
  Future waitDinnerrFuture() {
    return new Future(waitForDinner);
  }
  Future startChatFuture() {
    return new Future(startChat);
  }

  enterRestaurantFuture()
    .then((avalue) => waitDinnerrFuture()
    .then((bvalue) => startChatFuture()
    .then((cvalue) => 
      new Builder(builder: (BuildContext context) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('提示'),
            content: Text('多异步执行完成!'),
            actions: <Widget>[
              new RaisedButton(
                onPressed: () {
                  print('确定');
                },
                child: Text('确定'),
                textColor: Colors.orange
              )
            ]
          )
        );
      })
  )));
  //(!!!!以上内容暂无效果,后续优化~ ~ ~ ~ ~ ~)
    

  Future
    .wait([enterRestaurantFuture(), waitDinnerrFuture(), startChatFuture()])
    .then((List response){
      print('.wait-response: $response');
    })
    .catchError((err){
      print('.wait-err: $err');
    });
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('$name')),
      body: new Center(
          child: new GestureDetector(
              onTap: asyncdo,
              child: Text('$name', style: TextStyle(fontSize: 20.0)))),
    );
  }
}
