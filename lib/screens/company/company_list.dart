import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/booking_model.dart';

class CompanyList extends StatefulWidget {
  String name;
  static const routeName = '/userBookings';
   CompanyList({
    required this.name
   });

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Booking> bookingList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchBookings();
  }

  @override
  void fetchBookings() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("placesBookings");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Booking p = Booking.fromJson(event.snapshot.value);
      bookingList.add(p);
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
                            'قائمة الحجوزات',
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
                        itemCount: bookingList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (widget.name ==
                              bookingList[index].company) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            right: 15,
                                            left: 15,
                                            bottom: 10),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  'الاسم :  ${bookingList[index].name.toString()}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Cairo'),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  'رقم الهاتف: ${bookingList[index].phoneNumber.toString()}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Cairo'),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  'المكان السياحى : ${bookingList[index].place.toString()}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Cairo'),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  'عدد التذاكر المحجوزة : ${bookingList[index].amount.toString()}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Cairo'),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  'التاريخ : ${bookingList[index].date.toString()}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Cairo'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                  base
                                                      .child(bookingList[index]
                                                          .id
                                                          .toString())
                                                      .remove();
                                                },
                                                child: Icon(Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 122, 122, 122)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Text('');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
