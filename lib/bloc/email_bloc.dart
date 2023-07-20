import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}



class ChangeEmailInput extends ChangeEmailEvent{
  final String input;
  const ChangeEmailInput({required this.input});
}

abstract class ChangeEmailState extends Equatable {
  const ChangeEmailState();

  @override
  List<Object> get props => [];
}

class ChangeEmailInputState extends ChangeEmailState{
  final String input;
  const ChangeEmailInputState({required this.input});

  @override
  List<Object> get props => [];
}




class MiddleEmailInput extends ChangeEmailState{
  const MiddleEmailInput();

}

class ErrorState extends ChangeEmailState{
  const ErrorState();

}



class ChangeEmailInputBloc extends Bloc<ChangeEmailEvent,ChangeEmailState>{


  ChangeEmailInputBloc() : super(const MiddleEmailInput()) {
    on<ChangeEmailEvent>((event,emit)async{
      if(event is ChangeEmailInput){
        emit(const MiddleEmailInput());
        emit(ChangeEmailInputState(input:event.input));
      }
    },
    );

  }
}

