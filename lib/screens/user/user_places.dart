import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touristic_places/screens/user/places_details.dart';

import '../models/places_model.dart';

class UserPlaces extends StatefulWidget {
  String companyName;
  UserPlaces({required this.companyName});

  @override
  State<UserPlaces> createState() => _UserPlacesState();
}

class _UserPlacesState extends State<UserPlaces> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Places> placesList = [];
  List<Places> searchList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchPlaces();
  }

  @override
  void fetchPlaces() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("places").child('${widget.companyName}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Places p = Places.fromJson(event.snapshot.value);
      placesList.add(p);
      searchList.add(p);
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
                    'الأماكن السياحية',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(
                right: 20.w,
                left: 20.w,
              ),
              child: TextField(
                style: const TextStyle(
                  fontSize: 15.0,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xfff1665f), width: 32.0),
                      borderRadius: BorderRadius.circular(25.0)),
                  hintText: 'ابحث بالمنطقة',
                ),
                onChanged: (char) {
                  setState(() {
                    if (char.isEmpty) {
                      setState(() {
                        placesList = searchList;
                      });
                    } else {
                      placesList = [];
                      for (Places model in searchList) {
                        if (model.area!.contains(char)) {
                          placesList.add(model);
                        }
                      }
                      setState(() {});
                    }
                  });
                },
              ),
            ),
            Container(
              child: Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: placesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PlaceDetails(
                                    name: '${placesList[index].name}',
                                    price: '${placesList[index].price}',
                                    governorate: '${placesList[index].governorate}',
                                    area: '${placesList[index].area}',
                                    description: '${placesList[index].description}',
                                    imageUrl: '${placesList[index].imageUrl}',
                                    companyName: '${widget.companyName}',
                                  );
                                }));
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 20.w, left: 20.w),
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        '${placesList[index].imageUrl}',
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        '${placesList[index].name}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cairo',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${placesList[index].area}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
