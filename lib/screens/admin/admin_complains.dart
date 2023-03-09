import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touristic_places/screens/admin/send_replay.dart';
import 'package:touristic_places/screens/models/complains_model.dart';

import '../models/booking_model.dart';

class AdminComplains extends StatefulWidget {
  static const routeName = '/adminComplains';
  const AdminComplains({super.key});

  @override
  State<AdminComplains> createState() => _AdminComplainsState();
}

class _AdminComplainsState extends State<AdminComplains> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Complains> complainsList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchComplains();
  }

  @override
  void fetchComplains() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("userComplains");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Complains p = Complains.fromJson(event.snapshot.value);
      complainsList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
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
                                  backgroundImage:
                                      AssetImage('assets/images/logo.png'),
                                ),
                                SizedBox(
                                  width: 250.w,
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Color(0xfff8a55f), //<-- SEE HERE
                                  child: IconButton(
                                    icon: Center(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            'الشكاوى',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                      itemCount: complainsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 15, left: 15, bottom: 10),
                                  child: Column(children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'الشكوى : ${complainsList[index].description.toString()}',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'كود المشتكى: ${complainsList[index].userUid.toString()}',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: 120.w, height: 35.h),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xfff8a55f),
                                            ),
                                            child: Text('الرد على الشكوى'),
                                            onPressed: () async {
                                              
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return AdminReplay(
                                                  complain:
                                                      '${complainsList[index].description.toString()}',
                                                  uid:
                                                      '${complainsList[index].userUid.toString()}',
                                                );
                                              }));
                                              
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: 120.w, height: 35.h),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xfff8a55f),
                                            ),
                                            child: Text('مسح الشكوى'),
                                            onPressed: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          super.widget));
                                              base
                                                  .child(complainsList[index]
                                                      .id
                                                      .toString())
                                                  .remove();
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        );
                      },
                    ),
                    ),
                  ],
                ),
              )),
    );
  }
}
