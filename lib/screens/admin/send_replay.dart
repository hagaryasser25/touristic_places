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

import 'admin_home.dart';

class AdminReplay extends StatefulWidget {
  String uid;
  String complain;
  static const routeName = '/adminReplay';
  AdminReplay({
    required this.uid,
    required this.complain,
  });

  @override
  State<AdminReplay> createState() => _AdminReplayState();
}

class _AdminReplayState extends State<AdminReplay> {
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var maxLines = 5;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          
          body: Padding(
            padding: EdgeInsets.only(
              top: 10.h,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: Center(
                child: Column(
                  children: [
                   Image.asset(
                      'assets/images/logo.png',
                      height: 180.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  SizedBox(height: 40.h),
                    SizedBox(
                      height: 150.h,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 10,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'الرد',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: double.infinity, height: 65.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xfff8a55f),
                        ),
                        onPressed: () async {
                          String description =
                              descriptionController.text.trim();

                          if (description.isEmpty) {
                            CherryToast.info(
                                    title: Text('ادخل الرد'),
                                    actionHandler: () {},
                                  ).show(context);
                            return;
                          }

                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            String uid = user.uid;
                            int date = DateTime.now().millisecondsSinceEpoch;

                            DatabaseReference companyRef = FirebaseDatabase
                                .instance
                                .reference()
                                .child('adminReplays');

                            String? id = companyRef.push().key;

                            await companyRef.child(id!).set({
                              'id': id,
                              'userUid': widget.uid,
                              'description': description,
                              'userComplain': widget.complain,
                            });
                          }
                          showAlertDialog(context);
                        },
                        child: Text('ارسال الرد'),
                      ),
                    ),
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
    content: Text('تم ارسال الرد'),
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