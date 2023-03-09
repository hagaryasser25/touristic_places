import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:ndialog/ndialog.dart';
import 'package:touristic_places/screens/auth/signup.dart';
import 'package:touristic_places/widgets/background.dart';

import '../user/user_home.dart';
import 'admin_login.dart';
import 'company_login.dart';

class LoginPage extends StatefulWidget {

  static const routeName = '/loginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
            body: Stack(children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(
                        right: 70,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16, right: 32),
                            child:  TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                border: InputBorder.none,
                                icon: Icon(Icons.email),
                                hintText: "البريد الالكترونى",
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16, right: 32),
                            child:  TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 22),
                                border: InputBorder.none,
                                icon: Icon(Icons.password),
                                hintText: "كلمة السر",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          var email = emailController.text.trim();
                          var password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            MotionToast(
                                    primaryColor: Colors.blue,
                                    width: 300,
                                    height: 50,
                                    position: MotionToastPosition.center,
                                    description: Text("please fill all fields"))
                                .show(context);

                            return;
                          }
                          ProgressDialog progressDialog = ProgressDialog(
                              context,
                              title: Text('Logging In'),
                              message: Text('Please Wait'));
                          progressDialog.show();

                          try {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            UserCredential userCredential =
                                await auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                            if (userCredential.user != null) {
                              progressDialog.dismiss();
                              Navigator.pushNamed(
                                  context, UserHome.routeName);
                            }
                          } on FirebaseAuthException catch (e) {
                            progressDialog.dismiss();
                            if (e.code == 'user-not-found') {
                              MotionToast(
                                      primaryColor: Colors.blue,
                                      width: 300,
                                      height: 50,
                                      position: MotionToastPosition.center,
                                      description: Text("user not found"))
                                  .show(context);
                              return;
                            } else if (e.code == 'wrong-password') {
                              MotionToast(
                                      primaryColor: Colors.blue,
                                      width: 300,
                                      height: 50,
                                      position: MotionToastPosition.center,
                                      description:
                                          Text("wrong email or password"))
                                  .show(context);

                              return;
                            }
                          } catch (e) {
                            MotionToast(
                                    primaryColor: Colors.blue,
                                    width: 300,
                                    height: 50,
                                    position: MotionToastPosition.center,
                                    description: Text("something went wrong"))
                                .show(context);
                            print(e);

                            progressDialog.dismiss();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green[200]!.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xff1bccba),
                                Color(0xff22e2ab),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 45.w,
                  left: 45.w,
                ),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AdminLogin.routeName);
                        },
                        child: Text(
                          'تسجيل الدخول كأدمن',
                          style: TextStyle(color: Color(0xfff1665f)),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, CompanyLogin.routeName);
                        },
                        child: Text(
                          'تسجيل الدخول كشركة',
                          style: TextStyle(color: Color(0xfff1665f)),
                        )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 24),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpPage.routeName);
                      },
                      child: const Text(
                        "انشاء حساب",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffe98f60),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ])),
      ),
    );
  }
}
