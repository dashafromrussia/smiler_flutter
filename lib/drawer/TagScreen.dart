import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:smiler_flutter/drawer/drawer/OnePageScreen.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube/youtube.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.youtube.com/watch?v=k3Vfj-e1Ma4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
class TagScreen extends StatefulWidget {
  final String tag;

  const TagScreen({Key? key,required this.tag}) : super(key: key);

  @override
  State<TagScreen> createState() => _TagState();
}

class _TagState extends State<TagScreen> {

  int visiIndex = -1;
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AutoScrollController(
/*viewportBoundaryGetter: () =>
Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),*/
        axis: scrollDirection);
    controller.addListener((){
      // fun();
    });
  }

  void fun(int index,List<Map<String,dynamic>> data){
    print(index);
    if(index == data.length-1){
      print('laaaaaaaast');
    }
  }


  @override
  Widget build(BuildContext context) {
    final shareBloc = context.watch<ShareBloc>();
    final bloc = context.watch<MainBloc>();
    final blocTab = context.read<TabBloc>();
    final List<Map<String,dynamic>> articles = bloc.state is ChangeTypeState? (bloc.state as ChangeTypeState).data :[];
    final ipBloc = context.watch<IPBloc>();
    final String myIp = ipBloc.state is GetIPState ? (ipBloc.state as GetIPState).ip :'';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tags'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding:const EdgeInsets.only(bottom: 5,top: 10),
                    child: Text("Тег: ${widget.tag}",style: GoogleFonts.openSans(fontSize: 17,color:Colors.black38),)
                ),
                /* ElevatedButton(onPressed:(){
                  print(bloc.state);
                }, child: Text('aa')),*/
                Expanded(child:ListView.builder(
                  //   padding: const EdgeInsets.only(top: 40),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: articles.length,
                  shrinkWrap: true,
                  controller:controller,
                  //  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    fun(index, articles);
                    return  AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: GestureDetector(
                          /*onHorizontalDragDown: (){
                        print('auuaau');
                      },*/
                          onTap: (){
                            Navigator.pushReplacementNamed(context,'/oneart',arguments:{"id":articles[index]['id'],'views':articles[index]['views']});
                            //    bloc.add(AddViewEvent(articles[index].id));
                            //   print({"id":articles[index].id,"views":articles[index].views} is Map<String,int>);
                            //  Navigator.pushReplacementNamed(context,'/articles/one',arguments:{"id":articles[index].id,"views":articles[index].views});
                            /*if(!bloc.isClosed){
  bloc.add(AddViewEvent(articles[index].id));
  }*/
                          },
                          child: VisibilityDetector(
                            key: Key(index.toString()),
                            onVisibilityChanged: (visibilityInfo) {
                              var visiblePercentage = visibilityInfo.visibleFraction * 100;
                              if(visiblePercentage==100){
                                print(visibilityInfo);
                                print(visibilityInfo.key.toString());
                                if(visibilityInfo.key.toString()!=visiIndex){
                                  setState(() {
                                    final String keyData = visibilityInfo.key.toString().substring(3,visibilityInfo.key.toString().length-3);
                                    visiIndex =(int.parse(keyData));
                                  });
                                }
                              }
                              /* debugPrint(
                                'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');*/
                            },
                            child: Container(
                                padding: const EdgeInsets.all(30),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  // color: Colors.black87,
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 0.5,
                                  ),borderRadius: BorderRadius.circular(20),
                                ),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: Text("${articles[index]['time']}",style: GoogleFonts.openSans(fontSize: 15,color:Colors.black12 ))
                                        ),
                                      ],
                                    ),
                                    Container(
                                        padding:const EdgeInsets.only(bottom: 20),
                                        child: Text("${articles[index]['title']}",style: GoogleFonts.openSans(fontSize: 17,color:Colors.black38),)
                                    ),
                                    articles[index]['image'] is Uint8List ? Container(
                                      //   padding:const EdgeInsets.symmetric(vertical: 300),
                                      margin: const EdgeInsets.symmetric(vertical: 0.5),
                                      child: Image.memory(articles[index]['image'] as Uint8List, /*width: MediaQuery.of(context).size.width*0.9,height: 200*/fit: BoxFit.cover),
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
                                    /* articles[index]['url'] is String && articles[index]['url'].length > 0 ? Center(
                              //   padding:const EdgeInsets.symmetric(vertical: 100),
                                 //  margin: const EdgeInsets.all(20),
                                    child: Container(child:Image.network("${articles[index]['url']}"),
                                      decoration: BoxDecoration(
                                    //  border: Border.all(),borderRadius: BorderRadius.circular(20),
                                    ),),
                                   /* decoration: BoxDecoration(
                                     // color: Colors.black12,
                                      image:  DecorationImage(
                                        image: NetworkImage("${articles[index]['url']}",),
                                        fit: BoxFit.scaleDown,
                                      ),
                                      border: Border.all(
                              color: Colors.black12,
                             width: 1,
                            ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),*/
                                 //   width: MediaQuery.of(context).size.width*0.7,
                                //    height: 130,
                                  ):const SizedBox(),*/
                                    /* ElevatedButton(onPressed: (){
                                    print(articles[index]['video']);
                                  }, child:Text('asasa')),*/
                                    articles[index]['video'].toString() =="bbbbb" /*|| index!=visiIndex*/ ?const SizedBox():Videos(isVisi: visiIndex==index,idVideo: articles[index]['video'],),
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
                                                    child:Text("${articles[index]['views']}",style: GoogleFonts.openSans(fontSize: 10,color:Colors.black54))
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
                                                      String shareUrl = "smiler://id=${articles[index]['id']}&views=${articles[index]['views']}";
                                                      shareBloc.add(GetShareEvent(url: shareUrl));
                                                      // bloc.add(GiveLikesEvent((cookieBloc.state as CookieSuccessState).cookie));
                                                    }, icon:/*(bloc.state as ArticlesFinishData).article.likes
                                                .where((element) =>
                                            element==(cookieBloc.state as CookieSuccessState).cookie).toList().length!=0 ?*/
                                                    //  const Icon(Icons.heart_broken_outlined,color: Colors.red):
                                                    const Icon(Icons.share, color:Colors.black)),
                                                  ],
                                                )
                                            ),
                                            MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<LikesBloc>(
                                                      create: (context) =>LikesBloc()),
                                                ],
                                                child:Likess(data: articles[index], myIp: myIp)),
                                            // const SizedBox(height: 50,)
                                          ],
                                        ))
                                  ],
                                )
                            ),
                          ),
                        ));
                  },
                ) ),
              ],
            ),
          ),
        ),
      //  drawer: widget.drawerWidget
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
  final bool isVisi;
  final String idVideo;
  const Videos({Key? key, required this.isVisi,required this.idVideo}) : super(key: key);

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
    if(widget.isVisi){
      _controller.play();
    }else{
      _controller.pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    if(widget.isVisi){
      _controller.play();
    }else{
      _controller.pause();
    }
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



