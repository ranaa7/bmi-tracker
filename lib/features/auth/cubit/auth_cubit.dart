
import 'package:bloc/bloc.dart';
import 'package:bmi_tracker/core/network/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:meta/meta.dart';

import '../data/models/user_model.dart';
import '../presentation/screens/login_screen.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

 static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = true;
  bool isClicked = false;

  void changePasswordVisibility() {
    isVisible = !isVisible;
    emit(ChangePasswordVisibilityState());
  }

  void login() async {
    emit(UserLoginLoading());
    await auth
        .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((value) => emit(UserLoginSuccess(uId: value.user!.uid)))
        .catchError((e) => emit(UserLoginError(message: e.toString())));
    //Get.to(ChatScreen());
    // Get.offAll(BottomNavyScreen());

  }

  Future<void> signout() async {
    CacheHelper.removeData(key: 'uId');
    await auth.signOut();

  }



  void signup(

  ) async {
    emit(UserRegisterLoading());
    await auth
        .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((user) {
      emit(UserRegisterSuccess());
      saveuser(user, usernameController.text,emailController.text , );

      // saveUserPref(" ", " ", user.user!.uid!);
    }).catchError((e) {
      emit(UserRegisterError(message: e.toString()));
    });

    //Get.offAll(BottomNavyScreen());
  }

saveuser(
    UserCredential user,
    String name,
  String email,
  //  List pref,
    ) async {
  UserModel userModel = UserModel(
      name: name == "" ? user.user!.displayName! : name,
      email: user.user!.email!,
      userId: user.user!.uid,
    );
  await firestore
      .collection("users")
      .doc(user.user!.uid)
      .set(
      userModel.toJson()).then((value){
        emit(UserCreateSuccess());
  }).catchError((e){
        emit(UserCreateError(message: e.toString()));
      });
}
}
