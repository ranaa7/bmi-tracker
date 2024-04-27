import 'package:cloud_firestore/cloud_firestore.dart';

class BmiModel {
  String? BmiId;
  double? weight;
  double? height;
  double? age;
  double? bmi;

  DateTime? time;

  String? docId;



  BmiModel({
     this.age,
     this.weight,
    this.height,
 this.BmiId,
   this.time,
   this.bmi,
    this.docId
  });

  factory BmiModel.fromJson(Map<String, dynamic> json) {
    return BmiModel(
      age: json['age'],
      weight: json['weight'],
     height: json['height'],
      BmiId: json['uId'],
      time: (json['time'] as Timestamp).toDate(),
      bmi: json['bmi'],
      docId: json['docId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'weight': weight,
      'height': height,
      'uId': BmiId,
      'time': time != null ? Timestamp.fromDate(time!) : null,
      'bmi': bmi,
      'docId':docId
    };
  }
}