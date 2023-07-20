import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class ViewsEvent extends Equatable {
  const ViewsEvent();

  @override
  List<Object> get props => [];
}

class AddViewEvent extends ViewsEvent{
  final int views;
  final int id;
const AddViewEvent({required this.views,required this.id});
}





abstract class ViewsState extends Equatable {
  const ViewsState();

  @override
  List<Object> get props => [];
}


class ChangeViewsState extends ViewsState{
  final int views;

  const ChangeViewsState({required this.views});

  @override
  List<Object> get props => [views];

}



class MiddleViewsState extends ViewsState{
  const MiddleViewsState();

}



class ErrorState extends ViewsState{
  const ErrorState();

}

class ViewsBloc extends Bloc<ViewsEvent,ViewsState>{
  final int views;
  final int id;
  RemoteConfing remoteConfing = DataBaseConfig();
  ViewsBloc({required this.views,required this.id}) : super(const MiddleViewsState()) {
    on<ViewsEvent>((event,emit)async{
      if(event is AddViewEvent){
        emit(const MiddleViewsState());
        try{
          final int view = event.views+1;
         await remoteConfing.getView(view, id);
          emit(ChangeViewsState(views: event.views+1));
        }catch(e){
          const ErrorState();
        }

      }
    },
    );
    add(AddViewEvent(views: views, id: id));
  }

}
