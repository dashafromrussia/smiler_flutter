import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smiler_flutter/bloc/ip_bloc.dart';
import 'package:smiler_flutter/bloc/keep_scroll_bloc.dart';
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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
class Main extends StatefulWidget {
  final int idpost = 2;
  final String tag;
  final Widget drawerWidget;
  const Main({Key? key,required this.drawerWidget,required this.tag}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
 final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
 final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();
  int visiIndex = -1;
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AutoScrollController(
        axis: scrollDirection);
    controller.addListener((){
   // fun();
    });
  }

  void fun(List<Map<String,dynamic>> data,int sc,MainBloc bloc,String cat){
    bloc.add(GetPartEvent(off:data.length,cat:cat));
  }

  @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollBloc scrollBloc = context.watch<ScrollBloc>();
    final int scrollTo = scrollBloc.state is SaveScrollState? (scrollBloc.state as SaveScrollState).index :0;
    final shareBloc = context.watch<ShareBloc>();
    final bloc = context.watch<MainBloc>();
   final blocTab = context.read<TabBloc>();
   final String typeTab = blocTab is ToggleData? (blocTab as ToggleData).data:"video";
    final List<Map<String,dynamic>> articles = bloc.state is ChangeTypeState ? (bloc.state as ChangeTypeState).data :
    bloc.state is ChangePartState? (bloc.state as ChangePartState).data :
    bloc.state is CacheDataState? (bloc.state as CacheDataState).data :
    [];
     final ipBloc = context.watch<IPBloc>();
     final String myIp = ipBloc.state is GetIPState ? (ipBloc.state as GetIPState).ip :'';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Smiler'),
        ),
        body: SafeArea(
          child: Center(
            child: articles.isNotEmpty ?Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            const Tab(),
                const TabNew(),
                Container(
                    padding:const EdgeInsets.symmetric(vertical: 5),
                    child: Text("Тег: ${widget.tag}",style: GoogleFonts.openSans(fontSize: 17,color:Colors.black38),)
                ),
               Expanded(child:ScrollablePositionedList.builder(
                 itemScrollController: itemScrollController,
                 itemPositionsListener: itemPositionsListener,
                 scrollOffsetListener:scrollOffsetListener,
                 initialScrollIndex:scrollTo,
                  key: const PageStorageKey<String>('page'),
                  itemCount: articles.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return  AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: GestureDetector(
                        onTap: (){
                          scrollBloc.add(KeepScrollEvent(index: index));
                          Navigator.pushReplacementNamed(context,'/oneart',arguments:{"id":articles[index]['id'],'views':articles[index]['views']});
                        },
                        child: VisibilityDetector(
                          key: Key(index.toString()),
                          onVisibilityChanged: (visibilityInfo) {
                            print('VISISIIS');
                            print(index);
                            print(visibilityInfo.visibleFraction * 100);
                            if(visibilityInfo.visibleFraction * 100 > 72.71991166728009 && visiIndex!=index){
                              if(index==articles.length-1){
                                scrollBloc.add(KeepScrollEvent(index:articles.length-1));
                                fun(articles,scrollTo,bloc,typeTab);
                              }
                              setState(() {
                                visiIndex = index;
                              });
                              print(visibilityInfo);
                              print(visibilityInfo.key.toString());
                            /*  if(visibilityInfo.key.toString()!=visiIndex){
                                setState(() {
                                final String keyData = visibilityInfo.key.toString().substring(3,visibilityInfo.key.toString().length-3);
                                  visiIndex =(int.parse(keyData));
                                });
                              }*/
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
                                 // Text("${articles[index]['id']}"),
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
                                    borderRadius: BorderRadius.circular(100),
                                    ),
                                  ):const SizedBox(),
                                  articles[index]['video'].toString() =="bbbbb" /*|| index!=visiIndex*/ ?const SizedBox():Videos(isVisi: visiIndex==index,idVideo: articles[index]['video'],),
                                  const SizedBox(height: 20,),
                                  Center(
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Stack(
                                            children: [
                                              IconButton(onPressed:(){
                                              }, icon:
                                              const Icon(Icons.remove_red_eye_outlined, color:Colors.black)),
                                              Positioned(
                                                  left:37,
                                                  bottom:11,
                                                  child:Text("${articles[index]['views']}",style: GoogleFonts.openSans(fontSize: 10,color:Colors.black54))
                                              ),
                                            ],
                                          ),
                                          Container(
                                              child: Stack(
                                                children: [
                                                  IconButton(onPressed:(){
                                                    String shareUrl = "smileeer://id=${articles[index]['id']}&views=${articles[index]['views']}";
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
                )),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      scrollBloc.add(KeepScrollEvent(index:articles.length-1));
                      fun(articles,scrollTo,bloc,typeTab);
                    }, icon:const Icon(Icons.arrow_circle_down_outlined))
                  ],
                )*/
              ],
            ):const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 3,color: Colors.black,),
            ),
          ),
        ),
        drawer: widget.drawerWidget
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
        likes.contains(myIp) ? const Icon(Icons.heart_broken_sharp, color: Colors.red):
       const Icon(Icons.heart_broken_rounded, color: Colors.black)),
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
          bloc.add(GetDataEvent(cat:e['category'],off: 0));
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


class TabNew extends StatelessWidget {
  const TabNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocTab = context.watch<TabNewBloc>();
    final bloc = context.watch<MainBloc>();
    List<Map<String,dynamic>> data = blocTab.state is ToggleTabState?(blocTab.state as ToggleTabState).data:[];
    return Row(
      children: [
        ...data.map((e) =>Expanded(child:GestureDetector(onTap:(){
          blocTab.add(ToggleTabData(data:e['type']));
          bloc.add(ChangeTabTypeEvent(type:e['type']));
        },child: Container(
          padding: EdgeInsets.all(5),
          color: e['toggle'] ? Colors.yellow:Colors.black,
          child: Text("${e['type']}",style: TextStyle(color: e['toggle']?Colors.black:Colors.yellow),),
        ),),),).toList()
      ],
    );
  }
}




