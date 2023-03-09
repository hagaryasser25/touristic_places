import 'package:animated_flip_card/animated_flip_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:touristic_places/screens/admin/add_company.dart';
import 'package:touristic_places/screens/admin/admin_company.dart';
import 'package:touristic_places/screens/admin/admin_complains.dart';
import 'package:touristic_places/screens/company/admin_places.dart';
import 'package:touristic_places/screens/company/company_list.dart';
import 'package:touristic_places/screens/models/company_model.dart';
import 'package:touristic_places/screens/models/places_model.dart';

import '../auth/login.dart';
import '../models/users_model.dart';

class AdminHome extends StatefulWidget {
  static const routeName = '/adminHome';
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  late Users currentUser;

  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snapshot = await base.get();
    setState(() {
      currentUser = Users.fromSnapshot(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
            body: Column(
          children: [
            Container(
              height: 150.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [.01, .25],
                  colors: [
                    Color(0xfff8a55f),
                    Color(0xfff1665f),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        SizedBox(
                          width: 250.w,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xfff8a55f), //<-- SEE HERE
                          child: IconButton(
                            icon: Center(
                              child: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('تأكيد'),
                                      content:
                                          Text('هل انت متأكد من تسجيل الخروج'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.pushNamed(
                                                context, LoginPage.routeName);
                                          },
                                          child: Text('نعم'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('لا'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'الصفحة الرئيسية',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/park.jfif'),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AdminCompany.routeName);
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 10.w),
                        child: Center(
                          child: Column(children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Image.asset('assets/images/ad.png',
                                width: 120.w, height: 120.h),
                            SizedBox(
                              height: 10.h,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "أضافة شركات",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AdminComplains.routeName);
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 10.w),
                        child: Center(
                          child: Column(children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Image.asset('assets/images/co.png',
                                width: 120.w, height: 120.h),
                            SizedBox(
                              height: 10.h,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'الشكاوى',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
