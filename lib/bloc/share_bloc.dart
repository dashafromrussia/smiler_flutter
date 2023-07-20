import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class GetShareEvent extends ShareEvent{
final String url;
const GetShareEvent({required this.url});
}





abstract class ShareState extends Equatable {
  const ShareState();

  @override
  List<Object> get props => [];
}


class GetShareState extends ShareState{
  const GetShareState();

  @override
  List<Object> get props => [];

}



class MiddleShareState extends ShareState{
  const MiddleShareState();

}



class ErrorState extends ShareState{
  const ErrorState();

}

class ShareBloc extends Bloc<ShareEvent,ShareState>{

  static const platform = MethodChannel("com.smiler");
  Future<void> _getOpenUrl(String data) async {
    try {
      final result = await platform.invokeMethod('getUrl',data);
      print('result${result.toString()}result');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  ShareBloc() : super(const MiddleShareState()) {
    on<ShareEvent>((event,emit)async{
      if(event is GetShareEvent){
        _getOpenUrl(event.url);
       emit(const GetShareState());
      }
    },
    );
  }

}