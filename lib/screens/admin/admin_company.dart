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

class AdminCompany extends StatefulWidget {
  static const routeName = '/adminCompany';
  const AdminCompany({super.key});

  @override
  State<AdminCompany> createState() => _AdminCompanyState();
}

class _AdminCompanyState extends State<AdminCompany> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Company> companyList = [];
  List<String> keyslist = [];

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddCompany.routeName);
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // circular shape
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1bccba),
                      Color(0xff22e2ab),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
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
                              backgroundColor: Color(0xfff8a55f), //<-- SEE HERE
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
                                  onTap: () {},
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
                                              '${companyList[index].email}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              '${companyList[index].password}',
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          super.widget));
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('company')
                                                  .child(
                                                      '${companyList[index].id}')
                                                  .remove();
                                            },
                                            child: Icon(Icons.delete,
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122)),
                                          )
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
