import 'package:smiler_flutter/bloc/comment_bloc.dart';
import 'package:smiler_flutter/bloc/comment_bloc2.dart';
import 'package:smiler_flutter/bloc/dataComment_bloc.dart';
import 'package:smiler_flutter/bloc/email_bloc.dart';
import 'package:smiler_flutter/bloc/ip_bloc.dart';
import 'package:smiler_flutter/bloc/likes_bloc.dart';
import 'package:smiler_flutter/bloc/main_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:smiler_flutter/bloc/share_bloc.dart';
import 'package:smiler_flutter/bloc/singleArticle_bloc.dart';
import 'package:smiler_flutter/bloc/tabNew_bloc.dart';
import 'package:smiler_flutter/bloc/tab_bloc.dart';
import 'package:smiler_flutter/bloc/views_bloc.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube/youtube.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class OnePostWid extends StatelessWidget {

const OnePostWid({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final SingleArtBloc artBloc = context.watch<SingleArtBloc>();
    final Map<String,dynamic> article = artBloc.state is ChangeSinglTypeState? (artBloc.state as ChangeSinglTypeState).data :{};
    final ShareBloc shareBloc = context.watch<ShareBloc>();
    final ViewsBloc viewsBloc = context.watch<ViewsBloc>();
    final int views = viewsBloc.state is ChangeViewsState?(viewsBloc.state as ChangeViewsState).views:0;
    final ipBloc = context.watch<IPBloc>();
    final String myIp = ipBloc.state is GetIPState ? (ipBloc.state as GetIPState).ip :'';
    final DataCommentBloc commentBloc = context.watch<DataCommentBloc>();
    List<Map<String,dynamic>> list = commentBloc.state is GetCommentState?
    (commentBloc.state as GetCommentState).data:[];
    return Scaffold(
        appBar: AppBar(
            leading: GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context,'/',arguments: {'tag':'all','cat':article['category']});
              },
              child: const Icon(Icons.arrow_back,color: Colors.black,),
            ),
          title: const Text('Smiler'),
        ),
        body: SafeArea(
          child: Center(child:
           Container(padding: const EdgeInsets.all(30),
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              // color: Colors.black87,
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.5,
                              ),borderRadius: BorderRadius.circular(20),
                            ),
                            child:article.isNotEmpty ? ListView(
                             // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               /* ElevatedButton(onPressed:(){
                                  print(artBloc.state);
                                }, child: Text('aa')),*/
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text("${article['time']}",style: GoogleFonts.openSans(fontSize: 15,color:Colors.black12 ))
                                    ),
                                  ],
                                ),
                                Container(
                                    padding:const EdgeInsets.only(bottom: 20),
                                    child: Text("${article['title']}",style: GoogleFonts.openSans(fontSize: 17,color:Colors.black38),)
                                ),
                                article['image'] is Uint8List ? Container(
                                  //   padding:const EdgeInsets.symmetric(vertical: 300),
                                  margin: const EdgeInsets.symmetric(vertical: 0.5),
                                  child: Image.memory(article['image'] as Uint8List, /*width: MediaQuery.of(context).size.width*0.9,height: 200*/fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    // color: Colors.black87,
                                    /*border: Border.all(
                              //color: Colors.cyan,
                             // width: 5,
                            ),*/borderRadius: BorderRadius.circular(100),
                                  ),
                                  /*width: MediaQuery.of(context).size.width*0.9,
                                    height: 200,*/
                                ):const SizedBox(),
                                article['video'].toString() =="bbbbb" /*|| index!=visiIndex*/ ?const SizedBox():Videos(idVideo: article['video'],),
                                const SizedBox(height: 20,),
                                Center(
                                  //   margin:const EdgeInsets.only(top:10),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            IconButton(onPressed:(){
                                              // bloc.add(GiveLikesEvent((cookieBloc.state as CookieSuccessState).cookie));
                                            }, icon:/*(bloc.state as ArticlesFinishData).article.likes
                                                .where((element) =>
                                            element==(cookieBloc.state as CookieSuccessState).cookie).toList().length!=0 ?*/
                                            //  const Icon(Icons.heart_broken_outlined,color: Colors.red):
                                            const Icon(Icons.remove_red_eye_outlined, color:Colors.black)),
                                            Positioned(
                                                left:37,
                                                bottom:11,
                                                child:Text(views==0 ? "${article['views']}":"$views",style: GoogleFonts.openSans(fontSize: 10,color:Colors.black54))
                                            ),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            IconButton(onPressed:(){
                                              // bloc.add(GiveLikesEvent((cookieBloc.state as CookieSuccessState).cookie));
                                            }, icon:/*(bloc.state as ArticlesFinishData).article.likes
                                                .where((element) =>
                                            element==(cookieBloc.state as CookieSuccessState).cookie).toList().length!=0 ?*/
                                            //  const Icon(Icons.heart_broken_outlined,color: Colors.red):
                                            const Icon(Icons.comment, color:Colors.black)),
                                            Positioned(
                                                left:37,
                                                bottom:11,
                                                child:Text("${list.length}",style: GoogleFonts.openSans(fontSize: 10,color:Colors.black54))
                                            ),
                                          ],
                                        ),
                                        /*Container(
                                        child:Text("views:${articles[index]['views']}",style: GoogleFonts.openSans(fontSize: 15,color:Colors.black12 ),)
                                    ),*/
                                        /*  Container(
                                        child:Text("likes:${articles[index]['likes'].length}",style:GoogleFonts.openSans(fontSize: 15,color:Colors.black12 ))
                                    ),*/
                                        Container(
                                            child: Stack(
                                              children: [
                                                IconButton(onPressed:(){
                                                  String shareUrl = "smileeer://id=${article['id']}&views=${article['views']}";
                                                  shareBloc.add(GetShareEvent(url: shareUrl));

                                                }, icon:
                                                const Icon(Icons.share, color:Colors.black)),
                                              ],
                                            )
                                        ),
                                        MultiBlocProvider(
                                            providers: [
                                              BlocProvider<LikesBloc>(
                                                  create: (context) =>LikesBloc()),
                                            ],
                                            child:Likess(data: article, myIp: myIp)),
                                      ],
                                    )),
                              const SizedBox(height: 5,),
                                Text("${article['about']}",textAlign: TextAlign.center,style: GoogleFonts.openSans(fontSize: 16,color:Colors.black38),),
                                const SizedBox(height: 15,),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing:8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    ...article['tags'].map((e)=>
                                   GestureDetector(
                                     onTap:(){
                                       Navigator.pushNamed(context,'/tag',arguments: {'tag':e});
                                     },
                                       child:Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black
                                        ),
                                       borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      padding:const EdgeInsets.all(5),
                                      child: Text('$e', textAlign: TextAlign.center,style: const TextStyle(color: Colors.black,),),)))
                                  ],
                                ),
             MultiBlocProvider(
                 providers: [
                   BlocProvider<ChangeInputBloc>(
                       create: (context) => ChangeInputBloc()),
                   BlocProvider<ChangeTwoInputBloc>(
                       create: (context) => ChangeTwoInputBloc()),
                   BlocProvider<ChangeEmailInputBloc>(
                       create: (context) => ChangeEmailInputBloc()),
                 ],
                 child: CommentsWidget(idpost: article['id']))
                              ],
                            ):SizedBox()
                        ),
          ),
        ),
    );
  }
}


class CommentsWidget extends StatefulWidget {
  final int idpost;
  const CommentsWidget({Key? key, required this.idpost}) : super(key: key);

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {

  bool check = true;
  String whom = '';
  String isChecked = '';

  Future<void> sendEmail(String name, String email) async {
    print('eventt');
    String username = 'dariavladimirowna@gmail.com';
    String password = 'xaysgevibecqjzsr';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'dash')
      ..recipients.add(email)
      ..subject = 'Smiler comand :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Smiler</h1>\n<p>${name} ответил на ваш комментарий. Зайдите в приложение,чтобы посотреть! С уважением, Ваш Смайлер.</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final DataCommentBloc commentBloc = context.watch<DataCommentBloc>();
    List<Map<String,dynamic>> list = commentBloc.state is GetCommentState?
    (commentBloc.state as GetCommentState).data:[];
    final ChangeInputBloc changeInput= context.watch<ChangeInputBloc>();
    final ChangeTwoInputBloc changeTwoInput = context.watch<ChangeTwoInputBloc>();
    final ChangeEmailInputBloc changeEmail = context.watch<ChangeEmailInputBloc>();
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
    return Column(
      children: [
        const SizedBox(height: 10,),
        Container(
            padding:const EdgeInsets.only(bottom: 20),
            child: Text("Комментарии :",style: GoogleFonts.openSans(fontSize: 17,color:Colors.black38),)
        ),
        const Text(
          'Ваше имя :',
          style: textStyle,
        ),
        const SizedBox(height: 5),
        TextField(
          //controller: ,
            maxLength: 20,
            decoration: textFieldDecorator,
            onChanged: (text){
              changeInput.add(ChangeInput(input: text.trim()));
            } // print(email);},
        ),
        const SizedBox(height: 20),
        const Text(
          'Ваш комментарий :',
          style: textStyle,
        ),
        const SizedBox(height: 5),
        TextField(
          //controller: ,
            maxLength: 20,
            decoration: textFieldDecorator,
            onChanged: (text){
              changeTwoInput.add(ChangeTwoInput(input:text.trim()));
            } // print(email);},
        ),
        const SizedBox(height: 20),
        const Text(
          'Ваш email :',
          style: textStyle,
        ),
        const SizedBox(height: 5),
        TextField(
          //controller: ,
            maxLength: 60,
            decoration: textFieldDecorator,
            onChanged: (text){
             changeEmail.add(ChangeEmailInput(input: text.trim()));
            } // print(email);},
        ),
        Row(
          children: [
    Checkbox(
    checkColor: Colors.white,
    value:check,
    onChanged: (bool? value) {
    setState(() {
    check = value!;
    });
    },
    ),
          const SizedBox(width: 15,),
     Expanded(child: Text('Отправлять ответы на Ваши комментарий',
         style: GoogleFonts.openSans(fontSize: 15,color:Colors.black12 )))
          ],
        ),
        ElevatedButton(onPressed: ()async{
        String datat = DateTime.now().toString();
        datat = datat.substring(0,10);
        List<String> list = datat.split("-").reversed.toList();
        Map<String, dynamic> fin = {
          'id': list.length+1,
          'idpost': widget.idpost,
          'name': changeInput.state is ChangeInputState?(changeInput.state as ChangeInputState).input:'',
          'comment': changeTwoInput.state is ChangeTwoInputState?(changeTwoInput.state as ChangeTwoInputState).input:'',
          'time': list.join('-'),
          'whom': whom,
          'mail': changeEmail.state is ChangeEmailInputState?(changeEmail.state as ChangeEmailInputState).input:'',
          'notification':check? 'yes':'no'
        };
        commentBloc.add(SendComment(data: fin));
        if(isChecked=='yes' && whom.isNotEmpty && whom.contains("@")){
          await sendEmail(changeInput.state is ChangeInputState?(changeInput.state as ChangeInputState).input:'', whom);
        }
        }, child:Text('Отправить')),
        SizedBox(height: 10,),
            ...list.map((e) => GestureDetector(
              onTap: ()async{
                if(e['notification']=='yes'){
                  isChecked = 'yes';
                }
                whom = e['mail'];
                setState(() {

                });
                changeTwoInput.add(ChangeTwoInput(input:'${e['mail']},'));
              },
                child:Container(
              margin: EdgeInsets.symmetric(vertical: 10),
             // padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                //  color:Colors.black,
               //   borderRadius:BorderRadius.all(Radius.circular(5)) ,
                  //border: Border.all(color: Colors.blueAccent,)
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e["time"].toString(),style: const TextStyle(color: Colors.black,fontSize: 12),),
                  SizedBox(height: 5,),
                  Text(e["name"].toString(),style: const TextStyle(color: Colors.black,fontSize: 15),),
                  const SizedBox(height: 5,),
                  Text(e["comment"].toString(),style: const TextStyle(color: Colors.black,fontSize: 20),),
                  const SizedBox(height: 10,),
                  Row(children: [
                    const Expanded(child: const Divider(color: Colors.black54,height: 2,))
                  ],
                  ),
                ],
              )
              ,
            ))
            )
      ],
    );
  }
}





class Likess extends StatelessWidget {
  final Map<String,dynamic> data;
  final String myIp;
  const Likess({Key? key,required this.data,required this.myIp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LikesBloc likesBloc = context.watch<LikesBloc>();
    final List<String> likes = likesBloc.state is ChangeLikesState ?(likesBloc.state as ChangeLikesState).data:data['likes'];
    return Stack(
      children: [
        IconButton(onPressed:()async{
          likesBloc.add(GetLike(ip:myIp,id: data['id'],oldLikes:likes));
          print(myIp);
        }, icon:
        likes.contains(myIp) ? Icon(Icons.heart_broken_sharp, color: Colors.red):
        Icon(Icons.heart_broken_rounded, color: Colors.black)),
        Positioned(
            left:37,
            bottom:11,
            child:Text("${likes.length}",style: GoogleFonts.openSans(fontSize: 10,color:Colors.black54))
        ),
      ],
    );
  }
}



class Videos extends StatefulWidget {
  final String idVideo;
  const Videos({Key? key,required this.idVideo}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}





class _VideosState extends State<Videos> {

  late YoutubePlayerController _controller;

  void listenn(){
    print("value${_controller.value}");
    print('listeen');
  }

  @override
  void dispose() {
    _controller.pause();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.dispose();
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId:widget.idVideo,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Videos oldWidget) {
   /* if(widget.isVisi){
      _controller.play();
    }else{
      _controller.pause();
    }*/
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
   /* if(widget.isVisi){
      _controller.play();
    }else{
      _controller.pause();
    }*/
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // widget.isVisi? Text('1'):Text('0'),
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: (){
            _controller.addListener(listenn);
          },
        ),
      ],
    );
  }
}

class Tab extends StatelessWidget {
  const Tab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocTab = context.watch<TabBloc>();
    final bloc = context.watch<MainBloc>();
    final blocTabNew = context.read<TabNewBloc>();
    List<Map<String,dynamic>> data = blocTab.state is ToggleState?(blocTab.state as ToggleState).data:[];
    return Row(
      children: [
        ...data.map((e) =>Expanded(child:GestureDetector(onTap:(){
          blocTab.add(ToggleData(data:e['category']));
          bloc.add(ChangeTypeEvent(type:e['category']));
          blocTabNew.add(const ToggleTabData(data:'Случайные'));
        },child: Container(
          padding: EdgeInsets.all(5),
          color: e['toggle'] ? Colors.yellow:Colors.black,
          child: Text("${e['type']}",style: TextStyle(color: e['toggle']?Colors.black:Colors.yellow),),
        ),),),).toList()
      ],
    );
  }
}


