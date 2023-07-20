import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:smiler_flutter/bloc/admin_bloc.dart';
import 'package:smiler_flutter/data/remoteConfig.dart';


abstract class IPEvent extends Equatable {
  const IPEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetIp extends IPEvent {

  const GetIp();
}

abstract class IPState extends Equatable {
  const IPState();

  @override
  List<Object> get props => [];
}

class GetIPState extends IPState {
  final String ip;
 const GetIPState({required this.ip});

  @override
  List<Object> get props => [];
}




class NoIPState extends IPState {
  const NoIPState();

}

class ErrorState extends IPState {
  const ErrorState();

}



class IPBloc extends Bloc<IPEvent,IPState>{


  IPBloc() : super(const NoIPState()) {
    on<IPEvent>((event,emit)async{
      if(event is GetIp){
        try {
          /// Initialize Ip Address
          var ipAddress = IpAddress(type: RequestType.json);
          /// Get the IpAddress based on requestType.
          dynamic data = await ipAddress.getIpAddress();
          print(data['ip'].toString());
          emit(GetIPState(ip:data['ip'].toString()));
        } on IpAddressException catch (exception) {
          /// Handle the exception.
          print(exception.message);
        }
      }
    },
    );
    add(const GetIp());
  }
}

