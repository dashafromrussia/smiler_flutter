import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smiler_flutter/di_container.dart';
import 'package:smiler_flutter/navigation/routnames.dart';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

abstract class AppFactory {
  Widget makeApp();
}

final appFactory = makeAppFactory();


void main()async{
  runApp(appFactory.makeApp());
}

abstract class MyAppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName);
}

abstract class ScreenFactory {
  Widget makeAdminScreen();
  Widget makeMainScreen(Map<String,dynamic> tag);
  Widget makeDrawer(String select);
  Widget makeOneArticle(Map<String,dynamic> data);
  Widget makeTagScreen(Map<String,dynamic> tag);
}

bool _initialURILinkHandled = false ;

class MyApp extends StatefulWidget {

  final ScreenFactory screenFactory;
  const MyApp({Key? key,required this.screenFactory}) : super(key: key);

  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Color mainColor = const Color(0xFF9D50DD);





  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      // 2

      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          print(_initialURI);
          setState(() {
            _initialURI = initialURI;
          });
          String subStr =  initialURI.toString().substring(11);
          List<String> dataUrl = subStr.split("&");
          print(subStr.split("&"));
          final int id =int.parse(dataUrl[0].substring(3)) is int? int.parse(dataUrl[0].substring(3)):0;
          final int views =int.parse(dataUrl[1].substring(6)) is int? int.parse(dataUrl[1].substring(6)):0;
          Map<String,int> readyDatas = {"id":id,"views":views};
          print("readydataddd${readyDatas}");
          //   print("NAVIGATION${article}");
          MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/oneart',arguments:readyDatas,(route) => false);

        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException { // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) { // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }
  //adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "poligloto://unilinks2.example.com"'
  //adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://unilinks678.example.com"'
  void _incomingLinkHandler(){
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
        print( _currentURI);
        String subStr = uri.toString().substring(11);
        List<String> dataUrl = subStr.split("&");
        print(subStr.split("&"));
        final int id =int.parse(dataUrl[0].substring(3)) is int? int.parse(dataUrl[0].substring(3)):0;
        final int views =int.parse(dataUrl[1].substring(6)) is int? int.parse(dataUrl[1].substring(6)):0;
        Map<String,int> readyData = {"id":id,"views":views};
        print("readydata${readyData}");
        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/oneart',arguments:readyData,(route) => false);
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }


  Map<String, Widget Function(BuildContext)> get routes => {
    MainNavigationRouteNames.admin:(_)=>
        widget.screenFactory.makeAdminScreen(),
  };


  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tag:
        final arguments = settings.arguments;
        final args = arguments is Map ? arguments as Map<String,dynamic>:{'tag':'all'};
        return MaterialPageRoute(
          builder: (_) => widget.screenFactory.makeTagScreen(args),
        );
      case MainNavigationRouteNames.main:
        final arguments = settings.arguments;
        final args = arguments is Map ? arguments as Map<String,dynamic>:{'tag':'all','cat':"video"};
        return MaterialPageRoute(
          builder: (_) => widget.screenFactory.makeMainScreen(args),
        );
      case MainNavigationRouteNames.oneart:
        final arguments = settings.arguments;
        final data = arguments is Map ? arguments as Map<String,dynamic>:{"id": 0,"views": 0};
        final int id = data['id'] as int;
        final int views = data['views'] as int;
        final Map<String,int> dataFinish = {"id":id ,"views":views};
        return MaterialPageRoute(
          builder: (_) => widget.screenFactory.makeOneArticle(dataFinish),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }


  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName){
    List<Route<dynamic>> pageStack = [];
   pageStack.add(MaterialPageRoute(
        builder: (_) => widget.screenFactory.makeMainScreen({'tag':'all','cat':'video'}),
    ));
    return pageStack;
  }



  @override
  void initState() {
    _initURIHandler();
    _incomingLinkHandler();
    super.initState();
  }

  @override
  void dispose() {
     _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Smiler',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
    // initialRoute:MainNavigationRouteNames.main,
    onGenerateInitialRoutes:onGenerateInitialRoutes,
     onGenerateRoute: onGenerateRoute,
     routes: routes,
    );
  }
}





