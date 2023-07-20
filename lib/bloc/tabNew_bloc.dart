import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class TabNewEvent extends Equatable {
  const TabNewEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class ToggleTabData extends TabNewEvent {
  final String data;
  const ToggleTabData({required this.data});
}

abstract class TabNewState extends Equatable {
  const TabNewState();

  @override
  List<Object> get props => [];
}

class ToggleTabState extends TabNewState {
  final List<Map<String,dynamic>> data;
  final String type;
  ToggleTabState({required this.data,required this.type});

  @override
  List<Object> get props => [];
}




class MiddleState extends TabNewState {
  const MiddleState();

}

class ErrorState extends TabNewState {
  const ErrorState();

}



class TabNewBloc extends Bloc<TabNewEvent,TabNewState>{

  List<Map<String,dynamic>> data = [{'type':'Лучшее','toggle':false},{'type':'Новое','toggle':false},{'type':'Случайные','toggle':false}];


  TabNewBloc() : super(const MiddleState()) {
    on<TabNewEvent>((event,emit)async{
      if(event is ToggleTabData){
        data = data.map((e){
          e['toggle'] = false;
          if(e['type']==event.data){
            e['toggle'] = true;
          }
          return e;
        }).toList();
        emit(const MiddleState());
        emit(ToggleTabState(data:data,type:event.data));
      }
    },
    );
    add(const ToggleTabData(data:'Случайные'));
  }
}

