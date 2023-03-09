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
import 'package:touristic_places/screens/auth/login.dart';
import 'package:touristic_places/screens/models/company_model.dart';
import 'package:touristic_places/screens/user/send_complain.dart';
import 'package:touristic_places/screens/user/update_profile.dart';
import 'package:touristic_places/screens/user/user_bookings.dart';
import 'package:touristic_places/screens/user/user_places.dart';
import 'package:touristic_places/screens/user/user_replays.dart';

import '../models/users_model.dart';

class UserHome extends StatefulWidget {
  static const routeName = '/userHome';
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Company> companyList = [];
  List<String> keyslist = [];
  late Users currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCompany();
  }

  @override
  void fetchCompany() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("company");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Company p = Company.fromJson(event.snapshot.value);
      companyList.add(p);
      keyslist.add(event.snapshot.key.toString());
      print(keyslist);
      setState(() {});
    });
  }

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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
            key: _scaffoldKey,
            drawer: Container(
                width: 270.w,
                child: Drawer(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 200.h,
                        child: DrawerHeader(
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
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/logo.png'),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateProfile(
                                      email: currentUser.email,
                                      password: currentUser.password,
                                      name: '${currentUser.fullName}',
                                      phoneNumber: '${currentUser.phoneNumber}',
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid,
                                    );
                                  }));
                                },
                                title: Text('الملف الشخصى'),
                                leading: Icon(Icons.person),
                              ))),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, UserBookings.routeName);
                                },
                                title: Text('حجوزاتى'),
                                leading: Icon(Icons.book),
                              ))),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                   Navigator.pushNamed(
                                   context, SendComplain.routeName);
                                },
                                title: Text('ارسال شكوى'),
                                leading: Icon(Icons.ads_click),
                              ))),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                   Navigator.pushNamed(
                                   context, UserReplays.routeName);
                                },
                                title: Text('الردود على الشكاى'),
                                leading: Icon(Icons.app_registration),
                              ))),
                      Divider(
                        thickness: 0.8,
                        color: Colors.grey,
                      ),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('تأكيد'),
                                          content: Text(
                                              'هل انت متأكد من تسجيل الخروج'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                FirebaseAuth.instance.signOut();
                                                Navigator.pushNamed(context,
                                                    LoginPage.routeName);
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
                                title: Text('تسجيل الخروج'),
                                leading: Icon(Icons.exit_to_app_rounded),
                              )))
                    ],
                  ),
                )),
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
                              backgroundColor: Color(0xfff8a55f), //<-- SEE HERE
                              child: IconButton(
                                icon: Center(
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 250.w,
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/logo.png'),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'شركات الاعلان',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Image.asset('assets/images/back.png'),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w, left: 20.w),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Container(
                          child: StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: 15.w,
                              right: 15.w,
                              bottom: 15.h,
                            ),
                            crossAxisCount: 6,
                            itemCount: companyList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return UserPlaces(
                                        companyName:
                                            '${companyList[index].name}',
                                      );
                                    }));
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.w, left: 10.w),
                                      child: Center(
                                        child: Column(children: [
                                          Image.asset('assets/images/ad.png',
                                              height: 100.h),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              '${companyList[index].name}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              '${companyList[index].phoneNumber}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            staggeredTileBuilder: (int index) =>
                                new StaggeredTile.count(
                                    3, index.isEven ? 3 : 3),
                            mainAxisSpacing: 30.0,
                            crossAxisSpacing: 5.0.w,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
