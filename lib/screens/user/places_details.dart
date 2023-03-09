import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touristic_places/screens/user/book_ticket.dart';
import 'package:touristic_places/screens/user/places_description.dart';

class PlaceDetails extends StatefulWidget {
  String name;
  String price;
  String governorate;
  String area;
  String description;
  String imageUrl;
  String companyName;
  PlaceDetails(
      {required this.name,
      required this.price,
      required this.governorate,
      required this.area,
      required this.description,
      required this.imageUrl,
      required this.companyName});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
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
                      '${widget.name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, bottom: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: Image.network('${widget.imageUrl}'),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'سعر التذكرة : ${widget.price}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'المنطقة : ${widget.area}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'المحافظة : ${widget.governorate}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 40.w,
                  left: 30.w,
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BookTicket(
                            place: '${widget.name}',
                            company: '${widget.companyName}',
                          );
                        }));
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff1bccba), Color(0xff22e2ab)]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(minWidth: 88.0),
                          child: const Text('حجز تذكرة',
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlaceDescription(
                            name: '${widget.name}',
                            description: '${widget.description}',
                            imageUrl: '${widget.imageUrl}',
                          );
                        }));
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff1bccba), Color(0xff22e2ab)]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(minWidth: 88.0),
                          child: const Text('وصف المكان',
                              textAlign: TextAlign.center),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
