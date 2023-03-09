import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

import 'admin_company.dart';
import 'admin_home.dart';

class AddCompany extends StatefulWidget {
  static const routeName = '/addCompany';
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 180.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'الأسم',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'البريد الالكترونى',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'كلمة المرور',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'رقم الهاتف',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        String name = nameController.text.trim();
                        String email = emailController.text.trim();
                        String role = 'شركة';
                        String phoneNumber = phoneNumberController.text.trim();
                        String password = passwordController.text.trim();

                        if (name.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            phoneNumber.isEmpty ) {
                          CherryToast.info(
                            title: Text('Please Fill all Fields'),
                            actionHandler: () {},
                          ).show(context);
                          return;
                        }

                        if (password.length < 6) {
                          // show error toast
                          CherryToast.info(
                            title: Text(
                                'Weak Password, at least 6 characters are required'),
                            actionHandler: () {},
                          ).show(context);

                          return;
                        }

                        ProgressDialog progressDialog = ProgressDialog(context,
                            title: Text('Signing Up'),
                            message: Text('Please Wait'));
                        progressDialog.show();

                        try {
                          FirebaseAuth auth = FirebaseAuth.instance;

                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          User? user = userCredential.user;
                          user!.updateProfile(displayName: role);

                          if (userCredential.user != null) {
                            DatabaseReference userRef = FirebaseDatabase
                                .instance
                                .reference()
                                .child('company');
                            String? id = userRef.push().key;

                            String uid = userCredential.user!.uid;
                            int dt = DateTime.now().millisecondsSinceEpoch;

                            await userRef.child(id!).set({
                              'name': name,
                              'email': email,
                              'password': password,
                              'uid': uid,
                              'phoneNumber': phoneNumber,
                              'id': id,
                            });

                            DatabaseReference centerRef = FirebaseDatabase
                                .instance
                                .reference()
                                .child('users');

                            await centerRef.child(uid).set({
                              'name': name,
                              'email': email,
                              'password': password,
                              'uid': uid,
                              'dt': dt,
                              'phoneNumber': phoneNumber,
                            });

                            FirebaseAuth.instance.signOut();
                            Navigator.canPop(context)
                                ? Navigator.pop(context)
                                : null;
                          } else {
                            CherryToast.info(
                              title: Text('Failed'),
                              actionHandler: () {},
                            ).show(context);
                          }
                          progressDialog.dismiss();
                        } on FirebaseAuthException catch (e) {
                          progressDialog.dismiss();
                          if (e.code == 'email-already-in-use') {
                            CherryToast.info(
                              title: Text('Email is already exist'),
                              actionHandler: () {},
                            ).show(context);
                          } else if (e.code == 'weak-password') {
                            CherryToast.info(
                              title: Text('Password is weak'),
                              actionHandler: () {},
                            ).show(context);
                          }
                        } catch (e) {
                          progressDialog.dismiss();
                          CherryToast.info(
                            title: Text('Something went wrong'),
                            actionHandler: () {},
                          ).show(context);
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff1bccba), Color(0xff22e2ab)]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(minWidth: 88.0),
                          child: const Text('حفظ', textAlign: TextAlign.center),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: HexColor('#6bbcba'),
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, AdminHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم أضافة الشركة"),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
