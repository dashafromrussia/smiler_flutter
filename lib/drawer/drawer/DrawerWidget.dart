import 'package:flutter/material.dart';
import 'package:smiler_flutter/bloc/cookie_bloc.dart';
import 'package:smiler_flutter/bloc/drawer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class DrawerWidget extends StatelessWidget  /*State<DrawerWidget>*/ {


  @override
  Widget build(BuildContext context) {

    print('drawer');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(child:IconButton(onPressed:(){
    print('smile');
    },
        icon: const Icon(Icons.emoji_emotions_outlined, color:Colors.black,size: 100,)),
            decoration: const BoxDecoration(color: Colors.yellow),height: 200,),
         const SizedBox(height: 20,),
          DataWidget( select: 'Main', navigate: '/', name:'Главная',icon:Icons.emoji_emotions_outlined,),
          DataWidget( select: 'Admin', navigate: '/admin', name:'Админ-панель',icon:Icons.emoji_emotions_outlined,),
          DataWidget( select: 'Exit', navigate: '/admin', name:'Выход',icon:Icons.exit_to_app),
        ],
      ),
    );
  }
}

class DataWidget extends StatelessWidget {
  final IconData icon;
  final String select;
  final String navigate;
  final String name;
 const DataWidget({Key? key, required this.select,required this.icon,
    required this.name, required this.navigate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawerBloc>();
    final blocCookie = context.read<CookieBloc>();

    return StreamBuilder<DrawerState>(
      initialData:bloc.state,
      stream: bloc.stream,
      builder: (context, snapshot) {
        return
          ListTile(
            leading:Icon(icon,color:(snapshot.requireData as ToggleState).selects[select]),
            title:
            Text(name,style: TextStyle(color:(snapshot.requireData as ToggleState).selects[select])),
            onTap: (){
              Navigator.pop(context);
              if(select=='Exit'){
                blocCookie.add(const DeleteCookie());

              }

              if(select=='Main'){
                Navigator.pushReplacementNamed(context, navigate,arguments: {'tag':'all','cat':'video'});
              }else{
                Navigator.pushReplacementNamed(context, navigate);
              }

            },

          );
      },
    )
    ;
  }


}
