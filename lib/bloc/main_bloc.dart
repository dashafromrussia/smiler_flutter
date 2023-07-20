import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


/*abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}



class GetDataEvent extends MainEvent {
final int first;
final int last;
  const GetDataEvent({required this.first,required this.last});
}



class GetPartEvent extends MainEvent {
  final int first;
  final int last;
  const GetPartEvent({required this.first,required this.last});
}


class CloseEvent extends MainEvent {

  const CloseEvent();
}

class GetLikeEvent extends MainEvent {
  final int id;
  final String ip;
  const GetLikeEvent({required this.ip,required this.id});
}


class GetSuccess extends MainEvent {
  final List<Map<String,dynamic>> data;
    const GetSuccess({required this.data});
}

class ChangeTypeEvent extends MainEvent{
  final String type;

  const ChangeTypeEvent({required this.type});
}


class ChangeTabTypeEvent extends MainEvent{
  final String type;

  const ChangeTabTypeEvent({required this.type});
}


abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}


class SendSuccessState extends MainState {

  const SendSuccessState();

  @override
  List<Object> get props => [];

}
class BeginLoadState extends MainState {

  const BeginLoadState();

  @override
  List<Object> get props => [];

}


class MiddleState extends MainState {
  const MiddleState();

}

class ChangeTypeState extends MainState {
  final List<Map<String,dynamic>> data;
 ChangeTypeState({required this.data}){
    print(data);
  }

}
class ChangePartState extends MainState {
  final List<Map<String,dynamic>> data;
  ChangePartState({required this.data}){
    print(data);
  }

}

class ErrorState extends MainState {
  const ErrorState();

}

class CloseState extends MainState {
  const CloseState();

}


class DataState extends MainState{
  final List<Map<String,dynamic>> data;
  const DataState({required this.data});
}


class MainBloc extends Bloc<MainEvent,MainState>{
  final String tag;
  RemoteConfing remoteConfing;
  List<String> likes = [];
  int id =0;
  StreamSubscription <List<Map<String,dynamic>>>? d;
  StreamController <List<Map<String,dynamic>>>? dd;
  Stream<List<Map<String,dynamic>>>? streamData;
  List<Map<String,dynamic>> list = [];
    List<Map<String,dynamic>> categoryData = [];
    String category = 'Случайные';
  MainBloc({required this.remoteConfing,required this.tag}) : super(const MiddleState()) {
    on<MainEvent>((event,emit)async{
      print('gggfffff');
      if(event is GetDataEvent){
        try{
          List<Map<String,dynamic>> data = await remoteConfing.getData(event.first,event.last);
         if(tag=='all'){
            add(GetSuccess(data:data));
          }else{
            List<Map<String,dynamic>> dataTag = data.where((element) => element['tags'].contains(tag)).toList();
            add(GetSuccess(data:dataTag));
          }
        }catch(e){
          emit(const ErrorState());
        }finally{
        }
      }else if(event is GetSuccess){
        list =[/*...list,*/...event.data];
        print('one');
        print(list.length);
        print('two');
        categoryData = list.where((element) =>element['category']=='video').toList();
        emit(ChangeTypeState(data:list.where((element) =>element['category']=='video').toList()));
        print("finish datas${event.data}");
      }else if(event is ChangeTypeEvent){
        emit(const MiddleState());
        categoryData = list.where((element) =>element['category']==event.type).toList();
        print(list);
        print("type${event.type}");
        emit(ChangeTypeState(data:categoryData));
      }else if(event is ChangeTabTypeEvent){
        category = event.type;
        emit(const MiddleState());
        print(list);
        print("type${event.type}");
        emit(ChangeTypeState(data:categoryData.reversed.toList()));
      }
      else if(event is GetPartEvent){
        List<Map<String,dynamic>> data;
        try{
          data = await remoteConfing.getData(event.first,event.last);
          if(tag=='all'){
          }else{
             data= data.where((element) => element['tags'].contains(tag)).toList();
          }
          list =[...list,...data];
          print('one');
          print(list.length);
          print('two');
          categoryData = list.where((element) =>element['category']=='video').toList();
          emit(ChangePartState(data:list.where((element) =>element['category']=='video').toList()));
          print("finish datas${data}");
        }catch(e){
          emit(const ErrorState());
        }finally{
        }
      }
    },
    );
    add(const GetDataEvent(first: 3,last: 7));
  }

}*/
///////////////////////////////////
abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}



class GetDataEvent extends MainEvent {
final String cat;
final int off;
  const GetDataEvent({required this.cat,required this.off});
}



class GetPartEvent extends MainEvent {
  final String cat;
  final int off;
  const GetPartEvent({required this.cat,required this.off});
}





class GetSuccess extends MainEvent {
  final List<Map<String,dynamic>> data;
    const GetSuccess({required this.data});
}

class ChangeTypeEvent extends MainEvent{
  final String type;

  const ChangeTypeEvent({required this.type});
}


class ChangeTabTypeEvent extends MainEvent{
  final String type;

  const ChangeTabTypeEvent({required this.type});
}


abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}


class SendSuccessState extends MainState {

  const SendSuccessState();

  @override
  List<Object> get props => [];

}
class BeginLoadState extends MainState {

  const BeginLoadState();

  @override
  List<Object> get props => [];

}


class MiddleState extends MainState {
  const MiddleState();

}

class ChangeTypeState extends MainState {
  final List<Map<String,dynamic>> data;
 ChangeTypeState({required this.data}){
    print(data);
  }

}
class ChangePartState extends MainState {
  final List<Map<String,dynamic>> data;
  ChangePartState({required this.data}){
    print(data);
  }

}

class CacheDataState extends MainState {
  final List<Map<String,dynamic>> data;
  CacheDataState({required this.data}){
  }

}


class ErrorState extends MainState {
  const ErrorState();

}


class MainBloc extends Bloc<MainEvent,MainState>{
  final String cat;
  final String tag;
  RemoteConfing remoteConfing;
    List<Map<String,dynamic>> categoryData = [];
    String category = 'Случайные';
  MainBloc({required this.remoteConfing,required this.tag,required this.cat}) : super(const MiddleState()) {
    on<MainEvent>((event,emit)async{
      print('gggfffff');
      if(event is GetDataEvent){
        try{
          List<Map<String,dynamic>> data = await remoteConfing.getTagData(event.cat, event.off);
          if(tag=='all'){
            add(GetSuccess(data:data));
          }else{
            List<Map<String,dynamic>> dataTag = data.where((element) => element['tags'].contains(tag)).toList();
            add(GetSuccess(data:dataTag));
          }
        }catch(e){
          emit(const ErrorState());
        }finally{
        }
      }else if(event is GetSuccess){
        emit(const MiddleState());
       categoryData =[...event.data];
        print('one');
        print('two');
        emit(ChangeTypeState(data:categoryData));
        print("finish datas${event.data}");
      }else if(event is ChangeTabTypeEvent){
        category = event.type;
        emit(const MiddleState());
        print("type${event.type}");
        emit(ChangeTypeState(data:categoryData.reversed.toList()));
      }
      else if(event is GetPartEvent){
        emit(CacheDataState(data: categoryData));
        //emit(const MiddleState());
        List<Map<String,dynamic>> data;
        try{
          data = await remoteConfing.getTagData(event.cat, event.off);
          if(tag=='all'){
          }else{
             data= data.where((element) => element['tags'].contains(tag)).toList();
          }
          categoryData =[...categoryData,...data];
          print('one');
          print('two');
          emit(ChangePartState(data:categoryData));
          print("finish datas${data}");
        }catch(e){
          emit(const ErrorState());
        }finally{
        }
      }
    },
    );
    add(GetDataEvent(cat:cat,off:0));
  }

}

