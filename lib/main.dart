import 'package:bmi_tracker/core/network/cache_helper.dart';
import 'package:bmi_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/screens/register_screen.dart';
import 'features/home/cubit/bmi_calc_cubit.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Widget widget;
  var uId = CacheHelper.getData(key: 'uId');
  if(uId != null){
    widget = HomeScreen();
  }else{
    widget = LoginScreen();
  }
  runApp( MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
 MyApp({super.key , required this.startWidget});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BmiCalcCubit(),
      child: MaterialApp(

        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: startWidget,
      ),
    );
  }
}


