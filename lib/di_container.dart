import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/bloc/cookie_bloc.dart';
import 'package:smiler_flutter/bloc/dataComment_bloc.dart';
import 'package:smiler_flutter/bloc/drawer_bloc.dart';
import 'package:smiler_flutter/bloc/ip_bloc.dart';
import 'package:smiler_flutter/bloc/keep_scroll_bloc.dart';
import 'package:smiler_flutter/bloc/likes_bloc.dart';
import 'package:smiler_flutter/bloc/main_bloc.dart';
import 'package:smiler_flutter/bloc/share_bloc.dart';
import 'package:smiler_flutter/bloc/singleArticle_bloc.dart';
import 'package:smiler_flutter/bloc/tabNew_bloc.dart';
import 'package:smiler_flutter/bloc/tab_bloc.dart';
import 'package:smiler_flutter/bloc/views_bloc.dart';
import 'package:smiler_flutter/data/cookie_store.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';
import 'package:smiler_flutter/drawer/TagScreen.dart';
import 'package:smiler_flutter/drawer/drawer/OnePageScreen.dart';
import 'package:smiler_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:smiler_flutter/drawer/drawer/DrawerWidget.dart';
import 'package:smiler_flutter/drawer/AdminScreen.dart';
import 'package:smiler_flutter/drawer/MainScreen.dart';
import 'package:http/http.dart' as http;

AppFactory makeAppFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = _DIContainer();

  _AppFactoryDefault();

 /* @override
  Widget makeApp() {
    return
     MyApp(screenFactory: _diContainer.makeScreenFactory());
  }*/
 @override
  Widget makeApp() => MultiBlocProvider(
  providers: [
  BlocProvider<ScrollBloc>(
  create: (context) => _diContainer._makeScrollBloc()),
  BlocProvider<CookieBloc>(
  create: (_) => _diContainer._makeCookieBloc()),
  ],
  child: MyApp(screenFactory: _diContainer.makeScreenFactory()));
}




class _DIContainer {

  _DIContainer();


  final RemoteConfing _makeRemote= DataBaseConfig();

  CookieData _makeDataCookieProvider()=> CookieDataProvider();

  ScreenFactory makeScreenFactory() => ScreenFactoryDefault(this);

  DrawerBloc _makeDrawer(String select)=> DrawerBloc(select:select);

  CookieBloc _makeCookieBloc()=> CookieBloc(cookieData: _makeDataCookieProvider());

  AdminBloc _makeAdminBloc()=> AdminBloc(remoteConfing: _makeRemote);

  MainBloc _makeMainBloc(String tag, String cat)=> MainBloc(remoteConfing: _makeRemote,tag: tag,cat: cat);

  TabBloc _makeTabBlock(String cat)=> TabBloc(cat: cat);

  ScrollBloc _makeScrollBloc()=> ScrollBloc();

  TabNewBloc _makeTabNewBloc()=> TabNewBloc();

  IPBloc _makeIPBloc()=> IPBloc();

 ShareBloc _makeShareBloc()=> ShareBloc();

 LikesBloc _makeLikesBloc()=> LikesBloc();

 SingleArtBloc _makeArtBloc(int id)=> SingleArtBloc(id: id);

 ViewsBloc _makeViewBloc(int views,int id)=> ViewsBloc(views: views, id: id);

 DataCommentBloc _makeComments(int idpost)=> DataCommentBloc(remoteConfing:_makeRemote, idpost: idpost);
}


class ScreenFactoryDefault implements ScreenFactory {
  final _DIContainer _diContainer;


  ScreenFactoryDefault(this._diContainer);

  @override
  Widget makeDrawer(String select) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DrawerBloc>(
            create: (context) => _diContainer._makeDrawer(select)),
      ],
      child: DrawerWidget(),
    );
  }

  @override
  Widget makeMainScreen(Map<String,dynamic> tag){
    return MultiBlocProvider(
        providers: [
          BlocProvider<ShareBloc>(
              create: (context) => _diContainer._makeShareBloc()),
          BlocProvider<TabNewBloc>(
              create: (context) => _diContainer._makeTabNewBloc()),
          BlocProvider<TabBloc>(
              create: (context) => _diContainer._makeTabBlock(tag['cat'])),
          BlocProvider<MainBloc>(
              create: (context) => _diContainer._makeMainBloc(tag['tag'],tag['cat'])),
          BlocProvider<IPBloc>(
              create: (context) => _diContainer._makeIPBloc()),
        ],
        child: Main(drawerWidget: makeDrawer('Main'),tag: tag['tag'],));
  }


  @override
  Widget makeTagScreen(Map<String,dynamic> tag){
    return MultiBlocProvider(
        providers: [
          BlocProvider<ShareBloc>(
              create: (context) => _diContainer._makeShareBloc()),
          BlocProvider<TabNewBloc>(
              create: (context) => _diContainer._makeTabNewBloc()),
          BlocProvider<TabBloc>(
              create: (context) => _diContainer._makeTabBlock(tag['cat'])),
          BlocProvider<MainBloc>(
              create: (context) => _diContainer._makeMainBloc(tag['tag'],tag['cat'])),
          BlocProvider<IPBloc>(
              create: (context) => _diContainer._makeIPBloc()),
        ],
        child: TagScreen(tag: tag['tag'],));
  }


  @override
  Widget makeAdminScreen() {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<AdminBloc>(
              create: (context) => _diContainer._makeAdminBloc()),
        ],
        child: AdminScreen(drawerWidget:makeDrawer('Admin'),));
  }



  @override
  Widget makeOneArticle(Map<String, dynamic> data) {
   return MultiBlocProvider(
        providers: [
          BlocProvider<DataCommentBloc>(
              create: (context) =>_diContainer._makeComments(data['id'])),
          BlocProvider<IPBloc>(
              create: (context) => IPBloc()),
          BlocProvider<LikesBloc>(
              create: (context) =>_diContainer._makeLikesBloc()),
          BlocProvider<ViewsBloc>(
              create: (context) => _diContainer._makeViewBloc(data['views'], data['id'])),
          BlocProvider<ShareBloc>(
              create: (context) => _diContainer._makeShareBloc()),
          BlocProvider<SingleArtBloc>(
              create: (context) => _diContainer._makeArtBloc(data['id'])),
        ],
        child: const OnePostWid());
  }

}