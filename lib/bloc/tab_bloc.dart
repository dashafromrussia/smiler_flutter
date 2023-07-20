import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class ToggleData extends TabEvent {
final String data;
  const ToggleData({required this.data});
}

abstract class TabState extends Equatable {
const TabState();

  @override
  List<Object> get props => [];
}

 class ToggleState extends TabState {
  final List<Map<String,dynamic>> data;
  final String type;
   ToggleState({required this.data,required this.type});

  @override
  List<Object> get props => [];
}




class MiddleState extends TabState {
  const MiddleState();

}

class ErrorState extends TabState {
  const ErrorState();

}



class TabBloc extends Bloc<TabEvent,TabState>{
  final String cat;

List<Map<String,dynamic>> data = [{'type':'Картинки','toggle':false,'category':'picture'},{'type':'Статусы','toggle':false,'category':'status'},{'type':'Цитаты','toggle':false,'category':'quote'},
  {'type':'Видео','toggle':false,'category':'video'},{'type':'Анекдоты','toggle':false,'category':'joke'}];


  TabBloc({required this.cat}) : super(const MiddleState()) {
    on<TabEvent>((event,emit)async{
      if(event is ToggleData){
print('TOGGLE');
data = data.map((e){
  e['toggle'] = false;
  if(e['category']==event.data){
    e['toggle'] = true;
  }
  return e;
}).toList();
emit(const MiddleState());
emit(ToggleState(data: data,type:event.data));
      }
    },
    );
    add(ToggleData(data:cat));
  }
}

