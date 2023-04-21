import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/province_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tro_tot_app/views/gg_map_test.dart';
import 'package:tro_tot_app/views/home_page.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:tro_tot_app/views/map_predict.dart';
import 'package:tro_tot_app/views/post_page.dart';


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
        ChangeNotifierProvider(create: (_) => RoomViewModel()),
        ChangeNotifierProvider(create: (_) => ProvinceViewModel()),
      ],
      child: ScreenUtilInit(
        // designSize: const Size(1080, 1920),
        designSize: const Size(360, 640),
        builder: (BuildContext context, Widget? child) {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Login Demo',
            home:ListRoomPage(),
          );
        },
      ),
    );
  }
}
