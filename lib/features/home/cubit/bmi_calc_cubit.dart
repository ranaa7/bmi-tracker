
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../data/models/bmi_model.dart';

part 'bmi_calc_state.dart';

class BmiCalcCubit extends Cubit<BmiCalcState> {
  BmiCalcCubit() : super(BmiCalcInitial());

  static BmiCalcCubit get(context) => BlocProvider.of(context);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  double bmi = 0;
  BmiModel? bmiModel;

  double calculateBMIi(double weight, double height) {
    return weight / (height * height);
  }

  void calculateBMI() {
    final double weight = double.tryParse(weightController.text) ?? 0;
    final double height = double.tryParse(heightController.text) ?? 0;

    if (weight <= 0 || height <= 0) {
      emit(BmiCalcError("Invalid weight or height"));
      return;
    }

    bmi = weight / (height * height);
    final String status = getBMIStatus(bmi);
    //saveBmiData();
    emit(BmiCalcLoaded(bmi, status));
  }

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  String? savedDocId;


  saveBmiData() async {
    BmiModel bmiModel = BmiModel(
      BmiId: auth.currentUser!.uid,
      age: double.tryParse(ageController.text) ?? 0,
      weight: double.tryParse(weightController.text) ?? 0,
      height: double.tryParse(heightController.text) ?? 0,
      time: DateTime.now(),
      bmi: bmi,
    );
    DocumentReference docRef = await firestore
        .collection("bmi")
        .doc(auth.currentUser!.uid)
        .collection("entries")
        .add(bmiModel.toJson());
    savedDocId = docRef.id; // Store the document ID
  }



List<String> docIds = [];
  Stream<List<BmiModel>> getBmiData() {
    return firestore
        .collection("bmi")
        .doc(auth.currentUser!.uid)
        .collection("entries")
        .orderBy('time', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final docId = doc.id;
      print("prrrrr $docId");
      docIds.add(docId);
      return BmiModel.fromJson(doc.data())..docId = docId;
    }).toList());
  }

  void deleteBmiData(String docId) async {
    if (docId.isNotEmpty) {
      try {
        await firestore
            .collection("bmi")
            .doc(auth.currentUser!.uid)
            .collection("entries")
            .doc(docId)
            .delete();
        print("Entry with docId $docId deleted successfully.");
      } catch (error) {
        print("Error deleting entry with docId $docId: $error");
      }
    } else {
      print("No document ID provided to delete data.");
    }
  }



  void updateBmiData(String docId) async {
    //   await saveBmiData();
    BmiModel bmiModel = BmiModel(
        // docId: bmiModel.docId,
        age: double.tryParse(ageController.text) ?? 0,
        weight: double.tryParse(weightController.text) ?? 0,
        height: double.tryParse(heightController.text) ?? 0,
        time: DateTime.now(),
        bmi: bmi);
    print(bmiModel.BmiId);
    await firestore
        .collection("bmi")
        .doc(auth.currentUser!.uid)
        .collection("entries")
        .doc(docId)
        .update(bmiModel.toJson())
        .then((value) {
      print(bmiModel.BmiId);
      getBmiData();
      print(double.tryParse(ageController.text));
      print(double.tryParse(weightController.text));
      print(double.tryParse(heightController.text));
    }).catchError((e) {
      print("Error updating BMI data: $e");
    });
  }

}
