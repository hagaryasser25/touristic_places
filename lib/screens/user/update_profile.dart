import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:touristic_places/screens/auth/login.dart';

class UpdateProfile extends StatefulWidget {
  var email;
  var password;
  var name;
  var phoneNumber;
  var uid;
  static const routeName = '/updateProfile';
  UpdateProfile(
      {required this.email,
      required this.password,
      required this.name,
      required this.phoneNumber,
      required this.uid});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = '${FirebaseAuth.instance.currentUser!.email}';
    passwordController.text = '${widget.password}';
    nameController.text = '${widget.name}';
    phoneNumberController.text = '${widget.phoneNumber}';

    Future<String?> _changeEmail(
        String currentPassword, String newEmail) async {
      final user = await FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email.toString(), password: currentPassword);

      Map<String, String?> codeResponses = {
        // Re-auth responses
        "user-mismatch": null,
        "user-not-found": null,
        "invalid-credential": null,
        "invalid-email": null,
        "wrong-password": null,
        "invalid-verification-code": null,
        "invalid-verification-id": null,
        // Update password error codes
        "weak-password": null,
        "requires-recent-login": null
      };

      try {
        await user.reauthenticateWithCredential(cred);
        await user.updateEmail(newEmail);
        return null;
      } on FirebaseAuthException catch (error) {
        return codeResponses[error.code] ?? "Unknown";
      }
    }

    Future<String?> _changePssword(
        String currentPassword, String newPassword) async {
      final user = await FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email.toString(), password: currentPassword);

      Map<String, String?> codeResponses = {
        // Re-auth responses
        "user-mismatch": null,
        "user-not-found": null,
        "invalid-credential": null,
        "invalid-email": null,
        "wrong-password": null,
        "invalid-verification-code": null,
        "invalid-verification-id": null,
        // Update password error codes
        "weak-password": null,
        "requires-recent-login": null
      };

      try {
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
        return null;
      } on FirebaseAuthException catch (error) {
        return codeResponses[error.code] ?? "Unknown";
      }
    }

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
                    'الملف الشخصى',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(
                top: 20.h,
                right: 10.h,
                
              ),
              child: Row(
                children: [
                  Text('البريد الألكترونى'),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    height: 75.h,
                    width: 250.w,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor('#fdd47c'), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text('كلمة المرور'),
                SizedBox(
                  width: 37.w,
                ),
                SizedBox(
                  height: 75.h,
                  width: 250.w,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      fillColor: HexColor('#155564'),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#fdd47c'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text('الأسم'),
                SizedBox(
                  width: 65.w,
                ),
                SizedBox(
                  height: 75.h,
                  width: 250.w,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: HexColor('#155564'),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#fdd47c'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text('رقم الهاتف'),
                SizedBox(
                  width: 37.w,
                ),
                SizedBox(
                  height: 75.h,
                  width: 250.w,
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      fillColor: HexColor('#155564'),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#fdd47c'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 150.w, height: 50.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xfff8a55f),
                ),
                onPressed: () async {
                  _changeEmail(widget.password, emailController.text);
                  _changePssword(widget.password, passwordController.text);

                  User? user = await FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    DatabaseReference userRef = FirebaseDatabase.instance
                        .reference()
                        .child('users')
                        .child('${widget.uid}');

                    await userRef.update({
                      'email': emailController.text.trim(),
                      'password': passwordController.text.trim(),
                      'name': nameController.text.trim(),
                      'phoneNumber': phoneNumberController.text.trim(),
                    });
                  }
                  showAlertDialog(context);
                },
                child: Text('حفظ', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
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
      Navigator.pushNamed(context, LoginPage.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم التعديل يرجى تسجيل الدخول مجددا"),
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
