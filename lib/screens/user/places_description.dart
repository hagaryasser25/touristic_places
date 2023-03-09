import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceDescription extends StatefulWidget {
  String name;
  String description;
  String imageUrl;
  PlaceDescription(
      {required this.name, required this.description, required this.imageUrl});

  @override
  State<PlaceDescription> createState() => _PlaceDescriptionState();
}

class _PlaceDescriptionState extends State<PlaceDescription> {
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
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 15.w,
                  left: 15.w,
                ),
                child: Text(
                  '${widget.description}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
