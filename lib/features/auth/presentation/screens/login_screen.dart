import 'package:bmi_tracker/core/network/cache_helper.dart';
import 'package:bmi_tracker/features/auth/presentation/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = true;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is UserLoginSuccess){
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              print(state.uId);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            });
              }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title:  Center(
                child: Text(
                  'Login',
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Image.asset(
                        //     'assets/images/social-media.png',
                        //     width: MediaQuery.of(context).size.width / 3,
                        //   ),
                        // ),

                        const Text(
                          'Login now and discover app',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),

                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'email address must not be empty';
                            }

                            return null;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                              'email address',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }

                            return null;
                          },
                          controller: passwordController,
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
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(
                                isVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                          obscureText: isVisible,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          height: 42.0,
                          width: double.infinity,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: MaterialButton(
                            height: 42.0,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {


                                AuthCubit.get(context).login(emailController.text, passwordController.text);
                              }
                            },
                            child: isClicked
                                ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        Center(child: TextButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        }, child: Text("Signup if you don't have an account" , style: TextStyle(color: Colors.green[700]),))),
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
