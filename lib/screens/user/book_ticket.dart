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
import 'package:touristic_places/screens/user/user_home.dart';

class BookTicket extends StatefulWidget {
  String place;
  String company;
  static const routeName = '/addPlace';
  BookTicket({required this.place, required this.company});

  @override
  State<BookTicket> createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var amountController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
            body: Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                right: 10.w,
                left: 10.w,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 65.h,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xfff8a55f), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'الأسم',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    height: 65.h,
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xfff8a55f), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'رقم الهاتف',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'عدد التذاكر',
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'تاريخ الحجز',
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 25.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: double.infinity, height: 65.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                      ),
                      onPressed: () async {
                        String name = nameController.text.trim();
                        String phoneNumber = phoneNumberController.text.trim();
                        String amount = amountController.text.trim();
                        String date = dateController.text.trim();

                        if (name.isEmpty ||
                            phoneNumber.isEmpty ||
                            amount.isEmpty ||
                            date.isEmpty) {
                          CherryToast.info(
                            title: Text('ادخل جميع الحقول'),
                            actionHandler: () {},
                          ).show(context);
                          return;
                        }

                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          String uid = user.uid;

                          DatabaseReference companyRef = FirebaseDatabase
                              .instance
                              .reference()
                              .child('placesBookings');

                          String? id = companyRef.push().key;

                          await companyRef.child(id!).set({
                            'id': id,
                            'name': name,
                            'phoneNumber': phoneNumber,
                            'amount': amount,
                            'date': date,
                            'place': widget.place,
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                            'company': widget.company,
                          });
                        }
                        showAlertDialog(context);
                      },
                      child: Text('حجز', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
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
      Navigator.pushNamed(context, UserHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم الحجز"),
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
