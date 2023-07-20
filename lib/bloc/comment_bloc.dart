import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class ChangeEvent extends Equatable {
  const ChangeEvent();

  @override
  List<Object> get props => [];
}



class ChangeInput extends ChangeEvent{
final String input;
  const ChangeInput({required this.input});
}

abstract class ChangeState extends Equatable {
  const ChangeState();

  @override
  List<Object> get props => [];
}

 class ChangeInputState extends ChangeState{
  final String input;
  const ChangeInputState({required this.input});

  @override
  List<Object> get props => [];
}




class MiddleInput extends ChangeState{
  const MiddleInput();

}

class ErrorState extends ChangeState{
  const ErrorState();

}



class ChangeInputBloc extends Bloc<ChangeEvent,ChangeState>{


  ChangeInputBloc() : super(const MiddleInput()) {
    on<ChangeEvent>((event,emit)async{
      if(event is ChangeInput){
      emit(const MiddleInput());
      emit(ChangeInputState(input:event.input));
      }
    },
    );

  }
}

