import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/views/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'Login Demo',
            home: LoginPage(),
          );
        },
      ),
    );
  }
}
