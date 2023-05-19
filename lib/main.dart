import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/chat_view_model.dart';
import 'package:tro_tot_app/view_models.dart/province_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/gg_map_test.dart';
import 'package:tro_tot_app/views/list_room_page.dart';


import 'package:tro_tot_app/views/map_predict.dart';

void main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
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
        ChangeNotifierProvider(create: (_) => RoomViewModel()),
        ChangeNotifierProvider(create: (_) => ProvinceViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: Consumer<UserViewModel>(
        builder: (context, value, child) {
          print("Kiem tra dong nay"
              );
          if (FirebaseAuth.instance.currentUser != null) {
            value.getUser(FirebaseAuth.instance.currentUser!.uid);
          }
          return ScreenUtilInit(
            // designSize: const Size(1080, 1920),
            designSize: const Size(360, 640),
            builder: (BuildContext context, Widget? child) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Login Demo',
                home: ListRoomPage(),
              );
            },
          );
        },
      ),
    );
  }
}
