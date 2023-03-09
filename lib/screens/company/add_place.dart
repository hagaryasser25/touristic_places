import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touristic_places/screens/company/company_home.dart';

class AddPlace extends StatefulWidget {
  String companyName;
  static const routeName = '/addPlace';
  AddPlace({
    required this.companyName,
  });

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  String imageUrl = '';
  File? image;
  var nameController = TextEditingController();
  var governorateController = TextEditingController();
  var areaController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();

  Future pickImageFromDevice() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      image = tempImage;
      print(image!.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference refrenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await refrenceImageToUpload.putFile(File(xFile.path));

      imageUrl = await refrenceImageToUpload.getDownloadURL();
    } catch (error) {}
    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor:
                                    Color.fromARGB(255, 235, 234, 234),
                                backgroundImage:
                                    image == null ? null : FileImage(image!),
                              )),
                          Positioned(
                              top: 120,
                              left: 120,
                              child: SizedBox(
                                width: 50,
                                child: RawMaterialButton(
                                    // constraints: BoxConstraints.tight(const Size(45, 45)),
                                    elevation: 10,
                                    fillColor: Color(0xfff8a55f),
                                    child: const Align(
                                        // ignore: unnecessary_const
                                        child: Icon(Icons.add_a_photo,
                                            color: Colors.white, size: 22)),
                                    padding: const EdgeInsets.all(15),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Choose option',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Color(0xfff8a55f))),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          pickImageFromDevice();
                                                        },
                                                        splashColor:
                                                            HexColor('#FA8072'),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons.image,
                                                                  color: Color(
                                                                      0xfff8a55f)),
                                                            ),
                                                            Text('Gallery',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))
                                                          ],
                                                        )),
                                                    InkWell(
                                                        onTap: () {
                                                          // pickImageFromCamera();
                                                        },
                                                        splashColor:
                                                            HexColor('#FA8072'),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons.camera,
                                                                  color: Color(
                                                                      0xfff8a55f)),
                                                            ),
                                                            Text('Camera',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))
                                                          ],
                                                        )),
                                                    InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        splashColor:
                                                            HexColor('#FA8072'),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons
                                                                      .remove_circle,
                                                                  color: Color(
                                                                      0xfff8a55f)),
                                                            ),
                                                            Text('Remove',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'اسم المكان',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: governorateController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'اسم المحافظة',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: areaController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'المنطقة',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'سعر التذكرة',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                            borderSide: BorderSide(
                                color: Color(0xfff8a55f), width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'الوصف',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        String name = nameController.text.trim();
                        String governorate = governorateController.text.trim();
                        String area = areaController.text.trim();
                        String price = priceController.text.trim();
                        String description = descriptionController.text.trim();

                        if (name.isEmpty ||
                            governorate.isEmpty ||
                            area.isEmpty ||
                            price.isEmpty ||
                            description.isEmpty ||
                            imageUrl.isEmpty) {
                          CherryToast.info(
                            title: Text('Please Fill all Fields'),
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
                              .child('places').child('${widget.companyName}');

                          String? id = companyRef.push().key;

                          await companyRef.child(id!).set({
                            'id': id,
                            'imageUrl': imageUrl,
                            'name': name,
                            'governorate': governorate,
                            'area': area,
                            'price': price,
                            'description': description,
                          });
                        }
                        showAlertDialog(context);
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff1bccba), Color(0xff22e2ab)]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(minWidth: 88.0),
                          child: const Text('حفظ', textAlign: TextAlign.center),
                        ),
                      ),
                    )
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
      Navigator.pushNamed(context, CompanyHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم أضافة المكان"),
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
