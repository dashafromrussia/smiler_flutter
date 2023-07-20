import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class ChangeTwoEvent extends Equatable {
  const ChangeTwoEvent();

  @override
  List<Object> get props => [];
}



class ChangeTwoInput extends ChangeTwoEvent{
  final String input;
  const ChangeTwoInput({required this.input});
}

abstract class ChangeTwoState extends Equatable {
  const ChangeTwoState();

  @override
  List<Object> get props => [];
}

class ChangeTwoInputState extends ChangeTwoState{
  final String input;
  const ChangeTwoInputState({required this.input});

  @override
  List<Object> get props => [];
}




class MiddleTwoInput extends ChangeTwoState{
  const MiddleTwoInput();

}

class ErrorTwoState extends ChangeTwoState{
  const ErrorTwoState();

}



class ChangeTwoInputBloc extends Bloc<ChangeTwoEvent,ChangeTwoState>{

  ChangeTwoInputBloc() : super(const MiddleTwoInput()) {
    on<ChangeTwoEvent>((event,emit)async{
      if(event is ChangeTwoInput){
        emit(const MiddleTwoInput());
        emit(ChangeTwoInputState(input:event.input));
      }
    },
    );
  }
}