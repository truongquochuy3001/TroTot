import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/views/add_room_test.dart';
import 'package:tro_tot_app/views/home_page.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:tro_tot_app/views/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tro_tot_app/views/room_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // RoomData add = RoomData();
  // Room data1 = Room(
  //     name: "TPhòng trọ cao cấp cho thuê",
  //     address: "Kiệt 5 Văn Cao, Phường Xuân Phú, Thành phố Huế, Thừa Thiên Huế",
  //     price: 5000000,
  //     roomType: "Tro",
  //     capacity: 60,
  //     images: [
  //       "https://cdn.chotot.com/PcPy-icVuySyWCcOle20-25RF685VLgj_j82P9aMcqU/preset:view/plain/92602ca064c21ca70b0fb99d6ea6a711-2816533199628984471.jpg",
  //       "https://cdn.chotot.com/aSxlEsISJNPFe3xwc-zCxwtrfawLbvpwQrxn33C6DNk/preset:view/plain/268e56dbdce5e39dac8096fe3392bc13-2816533199711178746.jpg",
  //       "https://cdn.chotot.com/OIIKobWkDDJ_26xMWAkV7cQfOH1dbZpGuFJ2_zwWV2M/preset:view/plain/b3730ee829f1eb2f634691ff64a05541-2816533199742009944.jpg",
  //       "https://cdn.chotot.com/vZkZ8QeM7KloD3COsIILtEoDpFvzszrkBXrCXWOk2Fw/preset:view/plain/fc931ec6f1aabcb1ed60002d1c9be1cf-2816533199842388618.jpg",
  //       "https://cdn.chotot.com/b-PUJ3z1q8RJY75VlmtRWXAIzKDml_54reODMTaEklo/preset:view/plain/74a8d8721d73a87e123e8b7025a5127f-2816533199891716326.jpg"
  //     ],
  //     image:
  //         "https://cdn.chotot.com/LlUQTkDjWhp4h46a0IvBz0jwxKWzfPZMTtPxuDJE6zk/preset:listing/plain/92602ca064c21ca70b0fb99d6ea6a711-2816533199628984471.jpg",
  //     postingDate: "5 Ngày trước",
  //     status: true,
  //     description:
  //         "PHÒNG TRỌ CAO CẤP ĐẦY ĐỦ TIỆN NGHI\n\nHương Thủy, Thừa Thiên - Huế\n\n🏬 CƯ XÁ BÌNH AN🏬\n\n⚠️⚠️CHO THUÊ PHÒNG TRỌ CAO CẤP⚠️⚠️\n\n⛔️ 238 Sóng Hồng, Thuỷ Châu, Hương Thuỷ. \n⛔️ Phù hợp với người đi làm, gia đình nhỏ.\n⛔️ Phòng rộng rãi, wifi từng tầng, có camera an ninh.\n⛔️ Tiện nghi điều hòa, nóng lạnh, giường, nệm, tủ áo quần, tủ bếp\n\n 💯ĐẶC ĐIỂM VỊ TRÍ:\n✅ Cách các trường Đại Học Luật, Kinh Tế, Ngoại Ngữ khoảng hơn 7km. \n✅ Cách khu công nghiệp Phú Bài 4km\n✅ Gần chợ Phú Bài\n✅ Gần uỷ ban thị xã Hương Thuỷ\n✅ Gần sân vận động \n\n🔥GIÁ PHÒNG : 1,5 TRIỆU có nội thất đầy đủ🔥\n                       🔥 1,2 TRIỆU có nội thất cơ bản 🔥\n\n📣Liên hệ để thuê phòng \n 📲 SĐT: *** (Mr. Bảo)",
  //     furniture: true);
  // add.addRoom(data1, "123");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => RoomData())
      ],
      child: ScreenUtilInit(
        // designSize: const Size(1080, 1920),
        designSize: const Size(360, 640),
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Login Demo',
            home: ListRoomPage(),
          );
        },
      ),
    );
  }
}
