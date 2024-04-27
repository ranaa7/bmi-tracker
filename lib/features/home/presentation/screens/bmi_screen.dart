import 'package:bmi_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/bmi_calc_cubit.dart';
import '../../data/models/bmi_model.dart';

class BmiScreen extends StatelessWidget {
  const BmiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Entries'), actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.add , size: 30, color: Colors.blue,),
        ),
      ],),
      body: StreamBuilder<List<BmiModel>>(
        stream: BmiCalcCubit.get(context).getBmiData(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bmiEntries = snapshot.data ?? [];

          return ListView.builder(
            itemCount: bmiEntries.length,
            itemBuilder: (context, index) {
              final entry = bmiEntries[index];
              final docId = BmiCalcCubit.get(context).docIds[index];
              return ListTile(
                title: Column(children: [
                  Text(
                      'Weight: ${entry.weight}, Height: ${entry.height}, Age: ${entry.age}, BMI Total: ${entry.bmi}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end
                    ,
                    children: [
                    TextButton(
                        onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(index: entry.docId,)),
                      );
                    }, child: Text("Update" , style: TextStyle(color: Colors.green),)),
                    TextButton(onPressed: (){
                      print("this   ${entry.docId
                      }");
                      BmiCalcCubit.get(context).deleteBmiData(entry.docId ??'');

                    }, child: Text("Delete" , style: TextStyle(color: Colors.red),)),

                  ],)
                ],),

              );
            },
          );
        },
      ),
    );
  }
}
