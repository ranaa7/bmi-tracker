import 'package:bmi_tracker/features/auth/cubit/auth_cubit.dart';
import 'package:bmi_tracker/features/auth/cubit/auth_state.dart';
import 'package:bmi_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:bmi_tracker/features/home/presentation/screens/bmi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../cubit/bmi_calc_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.index});

  final String? index;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
     //   create: (context) => BmiCalcCubit(),
BlocProvider(create: (context) => BmiCalcCubit(),),
BlocProvider(create: (context) => AuthCubit(),),
      ],
      child: BlocBuilder<BmiCalcCubit, BmiCalcState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add BMI Entry'),
              actions: [
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {

                         AuthCubit.get(context).signout();
                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(builder: (context) => LoginScreen()),
                         );
                      },
                      icon: Icon(Icons.logout, size: 30, color: Colors.black,),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: BmiCalcCubit
                          .get(context)
                          .weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Weight (kg)'),
                    ),
                    TextField(
                      controller: BmiCalcCubit
                          .get(context)
                          .heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Height (m)'),
                    ),
                    TextField(
                      controller: BmiCalcCubit
                          .get(context)
                          .ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Age'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        BmiCalcCubit.get(context).calculateBMI();


                        // saveBMI(weight, height, age, bmi);

                      },
                      child: Text('calculate BMi'),
                    ),
                    SizedBox(height: 16.0),

                    if (state is BmiCalcLoaded)
                      Column(
                        children: [
                          Text('BMI: ${state.bmi}'),
                          Text('Status: ${state.status}'),
                        ],
                      ),
                    SizedBox(height: 20.0),

                    ElevatedButton(
                      onPressed: () {
                        BmiCalcCubit.get(context).saveBmiData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BmiScreen()),
                        );
                      },
                      child: Text('submit'),
                    ),
                    SizedBox(height: 20.0),

                    ElevatedButton(
                      onPressed: () {
                        BmiCalcCubit.get(context).updateBmiData(index ?? '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BmiScreen()),
                        );
                      },
                      child: Text('update'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
