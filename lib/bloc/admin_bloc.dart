import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';
import 'dart:isolate';
import 'dart:convert';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class SendData extends AdminEvent {
  final Map<String,String> data;
  const SendData({required this.data});
}

class GetData extends AdminEvent {

  const GetData();
}
class GetSuccess extends AdminEvent {

  const GetSuccess();
}

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}


class SendSuccessState extends AdminState {

  const SendSuccessState();

  @override
  List<Object> get props => [];

}



class MiddleState extends AdminState {
  const MiddleState();

}

class ErrorState extends AdminState {
  const ErrorState();

}
class DataState extends AdminState {
  const DataState();

}

class AdminBloc extends Bloc<AdminEvent,AdminState>{

 late StreamSubscription <List<Map<String,dynamic>>> d;

final RemoteConfing remoteConfing;



  AdminBloc({required this.remoteConfing}) : super(const MiddleState()) {
    on<AdminEvent>((event,emit)async{
      if(event is SendData){
        try{
          await remoteConfing.sendData(event.data);
          emit(const SendSuccessState());
        }catch(e){
          emit(const ErrorState());
        }
      }else if(event is GetData){
        await remoteConfing.getData(3,10);
      /*   d = remoteConfing.returnData().listen((event){
          print('event');
          print("event${event}");
          add(const GetSuccess());
        });*/
        /*if(state is DataState){
          print(state);
          d.cancel();
        }*/
       // d.cancel();
      /*  try{
          await remoteConfing.getData();
        }catch(e){*/
         /* print('afafafa');
          print(e.runtimeType);*/
          /*if(e is List<Map<String,dynamic>>){
            print("EeEeE${e}");
          }*/
        //}
      //  final receivePort = ReceivePort();
       /* final isolate = await Isolate
            .spawn(someFunction, {"port":receivePort.sendPort,'result':[],'fun':getDataForIsol,'dataUrl':'selectdata'});
        receivePort.listen((message) async{
          print(message);
          if(message is List<Map<String,dynamic>>){
            print("${message} post");
          }else{
            print("Erorrrr");
          }
          // изолят больше не нужен - завершаем его
          receivePort.close();
          isolate.kill();
        });*/
      //  throw UnimplementedError();
      }else if(event is GetSuccess){
        d.cancel();
        emit(const DataState());
      }
    },
    );
   // add(const GetData());
  }

/*static Future<void> someFunction(Map<String,dynamic> arg)async {
  print('isolateee');
  late SendPort port;
  final receivePort = ReceivePort();
  if (arg['port'] is SendPort) {
    port = arg['port'];
    final String parameters = jsonEncode(arg['result']);
    try {
      final data = await arg['fun'](parameters, arg['dataUrl']);
      print("isoooo${data}");
      port.send(data);
    } catch (e) {
      port.send(Exception());
    }
  }
}

Future<List<Map<String,dynamic>>> getDataForIsol(String parameters, String dataUrl)async{
    try{
     final data = await remoteConfing.getDataForIsolate(parameters, dataUrl);
     return data;
    }catch(e){
    throw  Exception();
    }

}*/


}



