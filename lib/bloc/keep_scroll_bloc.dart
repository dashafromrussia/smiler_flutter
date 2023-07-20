import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class ScrollEvent extends Equatable {
  const ScrollEvent();

  @override
  List<Object> get props => [];
}

class KeepScrollEvent extends ScrollEvent{
  final int index;
  const KeepScrollEvent({required this.index});
}





abstract class ScrollState extends Equatable {
  const ScrollState();

  @override
  List<Object> get props => [];
}


class SaveScrollState extends ScrollState{
  final int index;
  const SaveScrollState({required this.index});

  @override
  List<Object> get props => [];

}



class MiddleScrollState extends ScrollState{
  const MiddleScrollState();

}



class ErrorState extends ScrollState{
  const ErrorState();

}

class ScrollBloc extends Bloc<ScrollEvent,ScrollState>{



  ScrollBloc() : super(const MiddleScrollState()) {
    on<ScrollEvent>((event,emit)async{
      if(event is KeepScrollEvent){
        emit(const MiddleScrollState());
        emit(SaveScrollState(index:event.index));
      }
    },
    );
  }

}