import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class LikesEvent extends Equatable {
  const LikesEvent();

  @override
  List<Object> get props => [];
}

class LoadLike extends LikesEvent{

}

class GetLike extends LikesEvent {
  final int id;
  final String ip;
 final List<String> oldLikes;
  const GetLike({required this.ip,required this.id,required this.oldLikes});
}



abstract class LikesState extends Equatable {
  const LikesState();

  @override
  List<Object> get props => [];
}


class ChangeLikesState extends LikesState{
final List<String> data;
  const ChangeLikesState({required this.data});

  @override
  List<Object> get props => [];

}



class MiddleLikesState extends LikesState{
  const MiddleLikesState();

}



class ErrorState extends LikesState{
  const ErrorState();

}

class LikesBloc extends Bloc<LikesEvent,LikesState>{

  RemoteConfing remoteConfing = DataBaseConfig();
  LikesBloc() : super(const MiddleLikesState()) {
    on<LikesEvent>((event,emit)async{
      if(event is GetLike){
        List<String> midoldLikes = [];
        emit(const MiddleLikesState());
        print(event.oldLikes);
        print(event.ip);
        print(event.id);
        if(event.oldLikes.contains(event.ip)){

          midoldLikes = event.oldLikes.where((element) => element!=event.ip).toList();
        }else{
          midoldLikes =[...event.oldLikes,event.ip];
        }
        try{
          await remoteConfing.getLike(midoldLikes, event.id);
          emit(ChangeLikesState(data:midoldLikes));
        }catch(e){
          const ErrorState();
        }

      }
    },
    );
  }

}

/*class LikesBloc extends Bloc<LikesEvent,LikesState>{
 RemoteConfing remoteConfing;
  List<Map<String,dynamic>> likes =[];
  List<String> dataLikes = [];
  LikesBloc({required this.remoteConfing}) : super(const MiddleLikesState()) {
    on<LikesEvent>((event,emit)async{

  if(event is GetLike){
    emit(const MiddleLikesState());
    print('aa');
    if(likes.length==0){
      likes.add({'id':event.id,'likes':[event.ip]});
      dataLikes = [event.ip];
    }else{
      likes = likes.map((e){
        if(e['id']==event.id){
          if(e['likes'].contains(event.ip)){
            print('del');
            e['likes'] = e['likes'].where((w)=>w!=event.ip).toList();
          }else{
            print('add');
            e['likes'] = [...e['likes'],event.ip];
            dataLikes = e['likes'] as List<String>;
          }
        }else{
          likes.add({'id':event.id,'likes':[event.ip]});
          dataLikes = [event.ip];
        }
        return e;
      }).toList();
    }
       emit(ChangeLikesState(data:dataLikes));
      }else if(event is LoadLike){
    emit(ChangeLikesState(data:dataLikes));
  }
    },
    );
    add(LoadLike());
  }

}*/