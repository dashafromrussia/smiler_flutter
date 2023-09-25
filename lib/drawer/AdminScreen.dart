import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/bloc/cookie_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'dart:isolate';

class AdminScreen extends StatefulWidget {
  final Widget drawerWidget;
  const AdminScreen({Key? key,required this.drawerWidget}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CookieBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login to your account'),
        ),
        body: SafeArea(
          child: Center(
           child:bloc.state is CookieSuccessState? (bloc.state as CookieSuccessState).cookie=='admin123'?  HomePage():const Login():const Login()
          ),
        ),
        drawer: widget.drawerWidget
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _verticalGroupValue = "video";

  final _status = ["video","quote","joke"];
  final _status2 = ["status","picture"];
 String describe = '';
 String video = '';
 String tags = '';
 String title = "";
  Uint8List? imgBytes;





  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await result?.readAsBytes().then((value) => imgBytes = value);
    setState(() {
    });
    print("${bytes!.length}length");
    /*final String parameters = jsonEncode({'img':bytes.toString()});
    var uri = Uri.http('192.168.0.111:3500', 'addimg');
    final response = await http.Client()
        .post(uri, headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*///'}, body:parameters);
    // client.close();
    /*if (response.statusCode == 200) {
      final insertId = json.decode(response.body);
      print(insertId);
    } else {
      print('Errrorrr');
      throw Exception();
    }*/

  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdminBloc>();
    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
      fillColor: Colors.red,
      focusColor: Colors.red,
      hoverColor: Colors.red,
    );
    return
          Column(
            children: <Widget>[
              RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  horizontalAlignment: MainAxisAlignment.spaceAround,
                groupValue: _verticalGroupValue,
                onChanged: (value) => setState(() {
                  _verticalGroupValue = value ?? '';
                  print(value);
                }),
                items: _status,
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
                fillColor: Colors.black87
              ),
            const SizedBox(height: 10,),
              RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  horizontalAlignment: MainAxisAlignment.center,
                  groupValue: _verticalGroupValue,
                  onChanged: (value) => setState(() {
                    _verticalGroupValue = value ?? '';
                    print(value);
                  }),
                  items: _status2,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                  fillColor: Colors.black87
              ),
             Expanded(
               child:ListView(
                 padding:const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'Title',
                      style: textStyle,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      //controller: ,
                        maxLength: 20,
                        decoration: textFieldDecorator,
                        onChanged: (text){ title = text;
                        setState(() {

                        });
                        } // print(email);},
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Describe',
                      style: textStyle,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      maxLength: 20,
                      decoration: textFieldDecorator,
                      onChanged: (text){describe = text;
                      setState(() {

                      });
                     },

                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tags. Введите теги через запятую',
                      style: textStyle,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      maxLength: 20,
                      decoration: textFieldDecorator,
                      onChanged: (text){tags = text;
                      setState(() {

                      });
                      },
                    ),
                    const SizedBox(height: 20),
                _verticalGroupValue=='video'? Column(
                      children: [
                        const Text(
                          'Video',
                          style: textStyle,
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          maxLength: 50,
                          decoration: textFieldDecorator,
                          onChanged: (text){video = text;
                          setState(() {

                          });
                          },

                        ),
                        const SizedBox(height: 20),
                      ],
                    ):const SizedBox(),
                 _verticalGroupValue=='picture' ? Row(
                     children: [
                       const Text(
                         'Add picture:',
                         style: textStyle,
                       ),
                      const SizedBox(width: 40,),
                       IconButton(
                         icon: const Icon(Icons.add_a_photo_outlined,color: Colors.black87,size: 35,),
                         tooltip: 'Add picture',
                         onPressed: (){
                           getLostData();
                         }
                       ),
                       imgBytes!=null ? Container(width: 100,height: 100,child:Image.memory(imgBytes!)):const SizedBox(),
                     // const  SizedBox(width: 30,)
                     ],
                   ):const SizedBox(),
                   const SizedBox(height: 10,),
                    Center(child:ElevatedButton(onPressed:()async{
                      if(_verticalGroupValue == 'video' && video.isEmpty){
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Поле video пусто'),
                            content: const Text('Вставьте ссылку на видео'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      if(_verticalGroupValue == 'picture' && video.isEmpty){
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Поле picture пусто'),
                            content: const Text('Загрузите картинку'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                     // String u = 'https://www.youtube.com/watch?v=k3Vfj-e1Ma4';
                   // getIdFromUrl(u);
                      String datat = DateTime.now().toString();
                      datat = datat.substring(0,10);
                      List<String> list = datat.split("-").reversed.toList();
                      String timeNow = datat.split("-").reversed.toList().join('-');
                      String? videoId = getIdFromUrl(video);
                   final Map<String,String> result = {"category":_verticalGroupValue,"title":title.trim(),
                     "about":describe.trim(),"tags":tags.trim().toLowerCase(),"time":list.join('-'),"video":videoId ?? '',"image":imgBytes.toString()};
                    // bloc.add(SendData(data: result));
                      setState(() {
                       imgBytes = null;
                        title = '';
                        describe = '';
                        tags = '';
                        video = '';
                      });
                     /* final String parameters = jsonEncode(result);
                      var uri = Uri.http('192.168.0.111:3500', 'addata');
                      final response = await http.Client()
                          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Accept': '*///'}, body:parameters);
                      // client.close();
                    /*  if (response.statusCode == 200) {
                        final insertId = json.decode(response.body);
                        print(insertId);
                        imgBytes = null;
                        title = '';
                        describe = '';
                        tags = '';
                        video = '';
                        setState(() {
                        });
                      } else {
                        print('Errrorrr');
                        throw Exception();
                      }*/
                      print(result);
                    }, child:const Text('Сохранить данные'))),
                  ],
                ),
    ),
            ],
          );
  }
}




class AddImages extends StatefulWidget {
  const AddImages({Key? key}) : super(key: key);

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  Uint8List? imgBytes;
   Uint8List? img ;

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await result?.readAsBytes().then((value) => imgBytes = value);
    print("${bytes!.length}length");
   // Blob bl = Blob(bytes);
   // String imageBytesDecoded = base64.encode(bytes!);
    final String parameters = jsonEncode({'img':bytes.toString()});
    var uri = Uri.http('192.168.0.111:3500', 'addimg');
    final response = await http.Client()
        .post(uri, headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*'}, body:parameters);
    // client.close();
    if (response.statusCode == 200) {
      final insertId = json.decode(response.body);
      print(insertId);
    } else {
      print('Errrorrr');
      throw Exception();
    }

  }


  Future<void>getUsersData() async { //грузит всех пользов
    var uri = Uri.http('192.168.0.111:3500', 'getimg');
    final response = await http.Client()
        .post(uri,
        headers: {"Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'},body:jsonEncode([]));
    if (response.statusCode == 200) {
   //   print("RESPO${response.body}respose");
      final persons = json.decode(response.body);
    //  print('${persons}pesons');
     Map<String,dynamic> d = (persons as List)[0] as Map<String,dynamic>;
     print(d['img'].runtimeType);
     String ss = d['img'];
      String sub = ss.substring(1,ss.length-1);
      List<String> data  = sub.split(",");
      List<int> pars = data.map((e)=>int.parse(e)).toList();
      print("length${pars.length}");
      //List<dynamic> list = d['img']['data'];
    // print("${list.length}length");
    // Blob b = d['img'] as Blob;
      Uint8List image = Uint8List.fromList(pars);
      //List<int> bufferInt = d['img']['data'].map((e) => e as int).toList();
    /*  List<dynamic> list = d['img']['data'];
      final data = list.map((e) => e as int).toList();
      print("${data.length}length");
      BytesBuilder b = BytesBuilder();
      b.add(data);
    Uint8List listUnt =  b.takeBytes();

      String _imageBytesDecoded = base64.encode(listUnt);
      Uint8List finish = base64Decode(_imageBytesDecoded);
      print("${finish.length}finishh");*/
      //print( (d['img']['data'] as ByteBuffer).asInt8List().runtimeType);

     setState(() {
       img = image;
     });
     // return d;
    } else {
      print(response.statusCode);
      throw Exception();
    }
  }

//Image.memory(Uint8List.fromList(bufferInt))
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       img!=null ? Image.memory(img!):const SizedBox(),
        Container(child: ElevatedButton(onPressed: (){
        // getLostData();
   getUsersData();
    },child:const Text("dddd"))),
      ],
    );
  }
}


/*Future<bool>sendUserData(User user)async{     //добавл пользов
  final String parameters = jsonEncode(user.toJson());
  print("${parameters}user");
  var uri = Uri.http('192.168.0.111:3500', 'adduser');
  final response = await client
      .post(uri, headers: {"Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': '*///'}, body:parameters);
  // client.close();
 /* if (response.statusCode == 200) {
    final insertId = json.decode(response.body);
    print(insertId);
    return true;
  } else {
    print('Errrorrr');
    throw Exception();
  }
}*/
class MakeData extends StatefulWidget {
  const MakeData({Key? key}) : super(key: key);

  @override
  State<MakeData> createState() => _MakeDataState();
}

class _MakeDataState extends State<MakeData> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = 'admin123';
  String password = 'qwerty';
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CookieBloc>();
    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
      fillColor: Colors.red,
      focusColor: Colors.red,
      hoverColor: Colors.red,
    );
    return Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const _ErrorMessageWidget(),
        const Text(
          'Login',
          style: textStyle,
        ),
        const SizedBox(height: 5),
        TextField(
            maxLength: 50,
            decoration: textFieldDecorator,
            onChanged: (text){ email = text;
            setState(() {

            });
            } // print(email);},
        ),
        const SizedBox(height: 20),
        const Text(
          'Password',
          style: textStyle,
        ),
        const SizedBox(height: 5),
        TextField(
          maxLength: 20,
          decoration: textFieldDecorator,
          obscureText: true,
          onChanged: (text){password = text;
          setState(() {

          });
          print(password);},
        ),
        const SizedBox(height: 25),
        Center(child:ElevatedButton(onPressed:(){
          if(password=='qwerty' && email=='admin123'){
            bloc.add(const SetCookie(cookie:'admin123' ));
          }
        }, child:const Text('Войти'))),
        //  const SizedBox(width: 30),
      ],
    ),padding: EdgeInsets.all(10),) ;
  }
}
