import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class DrawerEvent extends Equatable {
  const DrawerEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class ToggleDrawer extends DrawerEvent {
  final String select;

  const ToggleDrawer(this.select);
  @override
  List<Object> get props => [select];
}

class ExitEvent extends DrawerEvent{

}



abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}


class ToggleState extends DrawerState {
  final  Map<String,Color> selects;
  const ToggleState(this.selects);


  @override
  List<Object> get props => [selects];


}



class DrawerBloc extends Bloc<DrawerEvent,DrawerState>{
  String select;
  DrawerBloc({required this.select}) : super(const ToggleState({'Books': Colors.black,'Main': Colors.black, 'Articles':Colors.black, 'Update': Colors.black,
    'Chats': Colors.black,'Users': Colors.black, 'Exit':Colors.black,'Forum':Colors.black})) {
    /* on<AppData>((event,emit){
     int data = (state as AppCount).count;
     print(data);
     data = data + 1;
     print(data);
    emit(AppCount(count: data));
  });*/
    on<ToggleDrawer>((event,emit){
      Map<String,Color>data =(state as ToggleState).selects;
      Map<String,Color>changedData = {};
      for(var item in data.entries){
        if(item.key==event.select.toString()){
          changedData[event.select] = Colors.grey;
          print(event.select);
        }else{
          changedData[item.key] = Colors.black;
        }
      }
      emit(ToggleState(changedData));
    },
    );
    on<ExitEvent>((event,emit)async{
      add(const ToggleDrawer('Exit'));
    });
    add(ToggleDrawer(select));

  }
}