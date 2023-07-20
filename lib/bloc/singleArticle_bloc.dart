import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class SingleArtEvent extends Equatable {
  const SingleArtEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetData extends SingleArtEvent {

  const GetData();
}





class GetSuccess extends SingleArtEvent {
  final Map<String,dynamic> data;
  const GetSuccess({required this.data});
}






abstract class SingleArtState extends Equatable {
  const SingleArtState();

  @override
  List<Object> get props => [];
}


class SendSuccessState extends SingleArtState{

  const SendSuccessState();

  @override
  List<Object> get props => [];

}
class BeginLoadState extends SingleArtState{

  const BeginLoadState();

  @override
  List<Object> get props => [];

}


class MiddleState extends SingleArtState {
  const MiddleState();

}

class ChangeSinglTypeState extends SingleArtState {
  final Map<String,dynamic> data;
  ChangeSinglTypeState({required this.data}){
    print(data);
  }

}


class ErrorState extends SingleArtState{
  const ErrorState();

}

class DataState extends SingleArtState{
  final List<Map<String,dynamic>> data;
  const DataState({required this.data});
}


class SingleArtBloc extends Bloc<SingleArtEvent,SingleArtState>{
  RemoteConfing remoteConfing = DataBaseConfig();
 final int id;
  late StreamSubscription <Map<String,dynamic>> d;

  SingleArtBloc({required this.id}) : super(const MiddleState()) {
    on<SingleArtEvent>((event,emit)async{
      if(event is GetData){
        try{
          Map<String,dynamic> data = await remoteConfing.getOneData(id);
          add(GetSuccess(data:data));
        /*  d = remoteConfing.returnOneData().listen((event){
            print('event');
            print("event${event}");
            add(GetSuccess(data:event));
          });*/
         // emit(const SendSuccessState());
        }catch(e){
          emit(const ErrorState());
        }

      }else if(event is GetSuccess){
      //  d.cancel();
        print("qqwww${event.data}");
   emit(ChangeSinglTypeState(data: event.data));
      }
    },
    );
    add(const GetData());
  }

}

