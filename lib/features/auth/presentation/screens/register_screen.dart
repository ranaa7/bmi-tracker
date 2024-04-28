import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AuthCubit(),
  child: BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if(state is UserCreateSuccess){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );    }
  },
  builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:  Padding(
            padding:  EdgeInsets.only(right: 30.w),
            child: Text(
              'Register',
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(20.0).r,
            child: Form(
              key: AuthCubit.get(context).formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    'Register now and discover app',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 40.0.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'username must not be empty';
                      }

                      return null;
                    },
                    controller: AuthCubit.get(context).usernameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding:  EdgeInsets.symmetric(
                        horizontal: 20.0.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      label: const Text(
                        'username',
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 20.0.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'email address must not be empty';
                      }

                      return null;
                    },
                    controller: AuthCubit.get(context).emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding:  EdgeInsets.symmetric(
                        horizontal: 20.0.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      label: const Text(
                        'email address',
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 20.0.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password is too short';
                      }

                      return null;
                    },
                    controller: AuthCubit.get(context).passwordController,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      label: const Text(
                        'password',
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          AuthCubit.get(context).changePasswordVisibility();
                        },
                        icon: Icon(
                          AuthCubit.get(context).isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: AuthCubit.get(context).isVisible,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                   SizedBox(
                    height: 40.0.h,
                  ),
                  Container(
                    height: 42.0.h,
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    child: MaterialButton(
                      height: 42.0.h,
                      onPressed: () {
                        if (AuthCubit.get(context).formKey.currentState!.validate()) {


                          AuthCubit.get(context).signup(

                          );

                        }
                      },
                      child: AuthCubit.get(context).isClicked
                          ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
),
);
  }
}
