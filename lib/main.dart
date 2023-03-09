import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:touristic_places/screens/admin/add_company.dart';
import 'package:touristic_places/screens/admin/admin_company.dart';
import 'package:touristic_places/screens/admin/admin_complains.dart';
import 'package:touristic_places/screens/auth/admin_login.dart';
import 'package:touristic_places/screens/auth/company_login.dart';
import 'package:touristic_places/screens/auth/login.dart';
import 'package:touristic_places/screens/auth/signup.dart';
import 'package:touristic_places/screens/company/company_home.dart';
import 'package:touristic_places/screens/user/send_complain.dart';
import 'package:touristic_places/screens/user/user_bookings.dart';
import 'package:touristic_places/screens/user/user_home.dart';
import 'package:touristic_places/screens/user/user_replays.dart';

import 'screens/admin/admin_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com'
              ? const AdminHome()
              : FirebaseAuth.instance.currentUser!.displayName == 'شركة'
                  ? const CompanyHome()
                  : UserHome(),
      routes: {
        SignUpPage.routeName: (ctx) => SignUpPage(),
        LoginPage.routeName: (ctx) => LoginPage(),
        AdminLogin.routeName: (ctx) => AdminLogin(),
        AddCompany.routeName: (ctx) => AddCompany(),
        CompanyHome.routeName: (ctx) => CompanyHome(),
        CompanyLogin.routeName: (ctx) => CompanyLogin(),
        UserHome.routeName: (ctx) => UserHome(),
        AdminHome.routeName: (ctx) => AdminHome(),
        UserBookings.routeName: (ctx) => UserBookings(),
        SendComplain.routeName: (ctx) => SendComplain(),
        AdminCompany.routeName: (ctx) => AdminCompany(),
        AdminComplains.routeName: (ctx) => AdminComplains(),
        UserReplays.routeName: (ctx) => UserReplays(),
        
      },
    );
  }
}
