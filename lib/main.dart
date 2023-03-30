import 'package:flutter/material.dart';
import 'package:tro_tot_app/uis/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tro_tot_app/uis/room_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://sqdjokefctvpkhsluzuj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNxZGpva2VmY3R2cGtoc2x1enVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODAwNTk2NzIsImV4cCI6MTk5NTYzNTY3Mn0.bWaYZHIPiarLI5ZDQsTiP4w4KFczVjHnyj3SgTXh98s',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          // title: 'Flutter Demo',
          // theme: ThemeData(
          //   // This is the theme of your application.
          //   //
          //   // Try running your application with "flutter run". You'll see the
          //   // application has a blue toolbar. Then, without quitting the app, try
          //   // changing the primarySwatch below to Colors.green and then invoke
          //   // "hot reload" (press "r" in the console where you ran "flutter run",
          //   // or simply save your changes to "hot reload" in a Flutter IDE).
          //   // Notice that the counter didn't reset back to zero; the application
          //   // is not restarted.
          //   primarySwatch: Colors.blue,
          // ),
          home: RoomDetailPage(),
        );
      },
      designSize: const Size(1080, 1920),
    );
  }
}
