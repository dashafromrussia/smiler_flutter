import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'dart:isolate';
import 'package:http/http.dart' as http;


abstract class RemoteConfing{
Future<void>sendData(Map<String,String> data);
Future<List<Map<String,dynamic>>>getTagData(String cat,int off);
Future<List<Map<String,dynamic>>> getTagDataForIsolate(Map<String,dynamic> parameters);
Future<List<Map<String,dynamic>>>getData(int first,int last);
Future<List<Map<String,dynamic>>> getDataForIsolate(Map<String,String> parameters);
//StreamController<List<Map<String,dynamic>>> returnData();
Future<void> getLike(List<String>like,int id);
Future<void> getView(int view,int id);
Future<Map<String,dynamic>> getOneData(int id);
Future<List<Map<String,dynamic>>> getPostComment(int idpost);
Future<void> getOneDataForIsolate(Map<String,dynamic>parameters);
Stream <Map<String,dynamic>> returnOneData();
Future<void> sendComment(Map<String, dynamic> data);
}


class DataBaseConfig implements RemoteConfing {

  final http.Client client = http.Client();

  static Future<void> someFunction(Map<String,dynamic> arg)async {
    print('isolateee');
    late SendPort port;
    final receivePort = ReceivePort();
    if (arg['port'] is SendPort) {
      port = arg['port'];
      print("rrrr${arg['result']}");
      print("rrrr${arg['dataUrl']}");
      print("rrrr${arg['fun']}");
      try{
  final data = await arg['fun'](arg['result'],arg['dataUrl']);
  print("isoooo${data}");
  port.send(data);
      }catch(e){
        print('eeeeee${e}');
        port.send(Exception());
      }
     /* var uri = Uri.http('192.168.0.111:3500', 'addata');
      final response = await http.Client()
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': }, body: parameters);
      // client.close();
      if (response.statusCode == 200) {
        final int insertId = json.decode(response.body) as int;
        print("${insertId}");
        port.send(insertId);
      } else {
        print('Errrorrr');
        port.send(Exception());
      }*/
    }
  }


 Future<int> sendDataForIsolate(Map<String,dynamic> parameters,String dataUrl)async{
    parameters['likes'] = jsonEncode(parameters['likes']);
   final String parameterss = jsonEncode(parameters);
    var uri = Uri.http('192.168.0.113:3500', dataUrl);
    final response = await client
        .post(uri, headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*'}, body: parameterss);
    // client.close();
    if (response.statusCode == 200) {
      final int insertId = json.decode(response.body) as int;
      print("${insertId}");
   return insertId;
    } else {
      print('Errrorrr');
     throw Exception();
    }
  }


  @override
  Future<void> sendData(Map<String, dynamic> data) async{
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':data,'fun':sendDataForIsolate,'dataUrl':'addata'});
    receivePort.listen((message) async{
      print(message);
      if(message is Map<String,dynamic>){
        print("${message}id int");
      }else{
        print("Erorrrr");
      }
      // изолят больше не нужен - завершаем его
      receivePort.close();
      isolate.kill();
    });
    throw UnimplementedError();
  }
  ////////

  @override
  Future<Map<String,dynamic>> getOneDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.113:3500', 'oneart');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '/'}, body: parameterss);
      // client.close();
      print(response.statusCode);
       print(response.body);
     // if (response.statusCode == 200) {
    //  Map e = json.decode(response.body) as Map<String,dynamic>;
      List list = json.decode(response.body) as List;
      Map<String,dynamic> e = list[0] as Map<String,dynamic>;
        print("ee${e}");
       List<String> tags = (e['tags'] as String).split(',').map((e) =>
            e.toString().trim()).toList();
        String sub;
        dynamic image;
        if (e['image'] as String == 'bbbbb') {
          image = 'bbbbb';
        } else {
          sub = e['image'].substring(1, e['image'].length - 1);
          List<String> data = sub.split(",");
          List<int> pars = data.map((e) => int.parse(e)).toList();
          image = Uint8List.fromList(pars);
        }
        final List<String> likes = (json.decode(e['likes']) as List).map((
            l) => l as String).toList();
        Map<String, dynamic> fin = {
          'id': e['id'] as int,
          'title': e['title'] as String,
          'video': e['video'] as String,
          'tags': tags,
          'about': e['about'] as String,
          'time': e['time'] as String,
          'views': e['views'] as int,
          'likes': likes,
          'url':e['url'] as String,
          'category': e['category'] as String,
          'image': image
        };

        print("fin finnnn${fin}");
      return fin;
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }



  final controllerOneArt =  StreamController<Map<String,dynamic>>();



  @override
  Stream<Map<String,dynamic>> returnOneData(){
    return controllerOneArt.stream;
  }

  @override
  Future<Map<String,dynamic>> getOneData(int id)async{
    Map<String,dynamic> data = await compute(getOneDataForIsolate,{'id':id});
    return data;
   // final receivePort = ReceivePort();
    /*final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,"result":{'id':id},'fun':getOneDataForIsolate,'dataUrl':'oneart'});
    receivePort.listen((message){
      print("oneneee${message}");
      if(message is Map<String,dynamic>){
        controllerOneArt.add(message);
        receivePort.close();
        print("List${message}List");
        isolate.kill();
      }
      else{
        isolate.kill();
        receivePort.close();
        //throw Exception();
      }
    });*/

  }

////////////

@override
  Future<List<Map<String,dynamic>>> getDataForIsolate(Map<String,dynamic> parameters)async{
    try {
       final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.113:3500', 'selectdata');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
        List list = json.decode(response.body) as List;
        print("listttttststst${list}");
        List<Map<String, dynamic>> res = list.map((e) {
          //print("ee${e}");
          List<String> tags = (e['tags'] as String).split(',').map((e) =>
              e.toString().trim()).toList();
          String sub;
          dynamic image;
          if (e['image'] as String == 'bbbbb') {
            image = 'bbbbb';
          } else {
            sub = e['image'].substring(1, e['image'].length - 1);
            List<String> data = sub.split(",");
            List<int> pars = data.map((e) => int.parse(e)).toList();
            image = Uint8List.fromList(pars);
          }
          final List<String> likes = (json.decode(e['likes']) as List).map((
              l) => l as String).toList();
          Map<String, dynamic> fin = {
            'id': e['id'] as int,
            'title': e['title'] as String,
            'video': e['video'] as String,
            'tags': tags,
            'about': e['about'] as String,
            'time': e['time'] as String,
            'views': e['views'] as int,
            'likes': likes,
            'url':e['url'] as String,
            'category': e['category'] as String,
            'image': image
          };
          // print("fin${fin}");
          print("fin finnnn${fin}");
          return fin;
        }
        ).toList();
        print("resresressss${res}");
        return res;
    /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
        throw(Exception(e));
    }
    }



  /*final controller =  StreamController<List<Map<String,dynamic>>>();

@override
StreamController <List<Map<String,dynamic>>> returnData(){
  print("take data");
    return controller;
  }*/

  @override
  Future<List<Map<String,dynamic>>> getData(int first,int last)async{
    List<Map<String,dynamic>> data;
    return compute(getDataForIsolate,{'first':first,'last':last});
   /* final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':'{}','fun':getDataForIsolate,'dataUrl':'selectdata'});
 receivePort.listen((message){
      print("mesmes${message}");
      if(message is List<Map<String,dynamic>>){
        controller.add(message);
        receivePort.close();
        print("List${message}List");
        isolate.kill();
      }else{
        isolate.kill();
        receivePort.close();
        throw Exception();
      }
    });*/
  }



  @override
  Future<void> getLike(List<String> likes,int id)async{
    List<Map<String,dynamic>> data;
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':{'likes':likes,'id':id},'fun':getLikeForIsolate,'dataUrl':'updatelike'});
    receivePort.listen((message){
      print("mesmes${message}");
      if(message=='1'){
        receivePort.close();
        //controller.add(message);
        print("Like${message}Like");
        isolate.kill();
      }else{
        isolate.kill();
        receivePort.close();
        throw Exception();
      }
    });
  }


  Future<String> getLikeForIsolate(Map<String,dynamic> parameters,String dataUrl)async{
    try {
      parameters['likes'] = jsonEncode(parameters['likes']);
      String resParams =jsonEncode(parameters);
      var uri = Uri.http('192.168.0.113:3500', dataUrl);
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body:resParams);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      String res = json.decode(response.body).toString();
      return res;
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

  Future<String> getViewsForIsolate(Map<String,dynamic> parameters,String dataUrl)async{
    try {
      String resParams =jsonEncode(parameters);
      print("paramsss${resParams}");
      var uri = Uri.http('192.168.0.113:3500', dataUrl);
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body:resParams);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      String res = json.decode(response.body).toString();
      return res;
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

@override
Future<void> getView(int view,int id)async{
  final receivePort = ReceivePort();
  final isolate = await Isolate
      .spawn(someFunction, {"port":receivePort.sendPort,'result':{'views':view,'id':id},'fun':getViewsForIsolate,'dataUrl':'updateview'});
  receivePort.listen((message){
    print("mesmes${message}");
    if(message=='1'){
      receivePort.close();
      //controller.add(message);
      print("views${message}views");
      isolate.kill();
    }else{
      isolate.kill();
      receivePort.close();
      throw Exception();
    }
  });
}

  @override
  Future<List<Map<String,dynamic>>> getPostComment(int idpost)async{
    List<Map<String,dynamic>>data = await compute(getCommentForIsolate,{'idpost':idpost});
    return data;
  }

  Future<List<Map<String,dynamic>>> getCommentForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.113:3500', 'loadpostcomments');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      List list = json.decode(response.body) as List;
      print("comment${list}");
      List<Map<String, dynamic>> res = list.map((e) {
        //print("ee${e}");

        Map<String, dynamic> fin = {
          'id': e['id'] as int,
          'idpost': e['idpost'] as int,
          'name': e['name'] as String,
          'comment': e['comment'] as String,
          'time': e['time'] as String,
          'time': e['time'] as String,
          'whom': e['whom'] as String,
          'mail': e['mail'] as String,
          'notification':e['notification'] as String
        };
        // print("fin${fin}");
        print("fin finnnn${fin}");
        return fin;
      }
      ).toList();
      print("resresressss${res}");
      return res;
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

  Future<int> sendCommentForIsolate(Map<String,dynamic> parameters,String dataUrl)async{
    final String parameterss = jsonEncode(parameters);
    var uri = Uri.http('192.168.0.113:3500', dataUrl);
    final response = await client
        .post(uri, headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*'}, body: parameterss);
    // client.close();
    if (response.statusCode == 200) {
      final int insertId = json.decode(response.body) as int;
      print("${insertId}");
      return insertId;
    } else {
      print('Errrorrr');
      throw Exception();
    }
  }


  @override
  Future<void> sendComment(Map<String, dynamic> data) async{
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':data,'fun':sendCommentForIsolate,'dataUrl':'addcomment'});
    receivePort.listen((message) async{
      print(message);
      if(message is int){
        print("${message}idcom int");
      }else{
        print("Erorrrr");
      }
      // изолят больше не нужен - завершаем его
      receivePort.close();
      isolate.kill();
    });
  }


  @override
  Future<List<Map<String,dynamic>>> getTagDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.113:3500', 'selectcat');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      List list = json.decode(response.body) as List;
      print("listttttststst${list}");
      List<Map<String, dynamic>> res = list.map((e) {
        //print("ee${e}");
        List<String> tags = (e['tags'] as String).split(',').map((e) =>
            e.toString().trim()).toList();
        String sub;
        dynamic image;
        if (e['image'] as String == 'bbbbb') {
          image = 'bbbbb';
        } else {
          sub = e['image'].substring(1, e['image'].length - 1);
          List<String> data = sub.split(",");
          List<int> pars = data.map((e) => int.parse(e)).toList();
          image = Uint8List.fromList(pars);
        }
        final List<String> likes = (json.decode(e['likes']) as List).map((
            l) => l as String).toList();
        Map<String, dynamic> fin = {
          'id': e['id'] as int,
          'title': e['title'] as String,
          'video': e['video'] as String,
          'tags': tags,
          'about': e['about'] as String,
          'time': e['time'] as String,
          'views': e['views'] as int,
          'likes': likes,
          'url':e['url'] as String,
          'category': e['category'] as String,
          'image': image
        };
        // print("fin${fin}");
        print("fin finnnn${fin}");
        return fin;
      }
      ).toList();
      print("resresressss${res}");
      return res;
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }



  /*final controller =  StreamController<List<Map<String,dynamic>>>();

@override
StreamController <List<Map<String,dynamic>>> returnData(){
  print("take data");
    return controller;
  }*/

  @override
  Future<List<Map<String,dynamic>>> getTagData(String cat,int off)async{
    return compute(getTagDataForIsolate,{'cat':cat,'off':off});
    /* final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':'{}','fun':getDataForIsolate,'dataUrl':'selectdata'});
 receivePort.listen((message){
      print("mesmes${message}");
      if(message is List<Map<String,dynamic>>){
        controller.add(message);
        receivePort.close();
        print("List${message}List");
        isolate.kill();
      }else{
        isolate.kill();
        receivePort.close();
        throw Exception();
      }
    });*/
  }


}