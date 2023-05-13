import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/user_model.dart';

import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:tro_tot_app/views/login_page.dart';
import 'package:tro_tot_app/views/profile_page.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({Key? key}) : super(key: key);

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordDup = TextEditingController();
  TextEditingController oldPassword = TextEditingController();

  AuthViewModel authViewModel = AuthViewModel();
  UserViewModel userViewModel = UserViewModel();

  bool? emailNull;
  bool? passWordNull;
  bool? isValid;
  bool? oldPasswordNull;
  bool? checkOldPassword;
  bool? checkLengthPass;
  bool? dupPasswordNull;
  bool? checkDupPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20.w,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                _titleText(context, "Đổi mật khẩu", ""),
                SizedBox(
                  height: 80.h,
                ),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Nhập mật khẩu cũ"),
                SizedBox(
                  height: 4.h,
                ),
                _oldPasswordInput(context),
                oldPasswordNull == true
                    ? Text(
                        "Vui lòng nhập mật khẩu cũ",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Mật khẩu"),
                SizedBox(
                  height: 4.h,
                ),
                _passwordInput(context),
                passWordNull == true
                    ? Text(
                        "Vui lòng nhập mật khẩu",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      )
                    :const SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Nhập lại mật khẩu"),
                SizedBox(
                  height: 4.h,
                ),
                _passwordDupInput(context),
                dupPasswordNull == true
                    ? Text(
                        "Vui lòng nhập lại mật khẩu",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      )
                    : checkDupPassword == false
                        ? Text(
                            "Mật khẩu không trùng khớp",
                            style:
                                TextStyle(color: Colors.red, fontSize: 14.sp),
                          )
                        : const SizedBox(),
                SizedBox(
                  height: 60.h,
                ),
                Center(child: _registerButton(context)),
                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleText(BuildContext context, String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color.fromARGB(255, 86, 86, 86),
          ),
        ),
      ],
    );
  }

  Widget _inputLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        color: const Color.fromARGB(255, 107, 107, 107),
      ),
    );
  }

  Widget _emailInput(BuildContext context) {
    return TextField(
      controller: email,
      onChanged: (value) {},
    );
  }

  Widget _oldPasswordInput(BuildContext context) {
    return TextField(
      controller: oldPassword,
      obscureText: true,
      onChanged: (value) {},
    );
  }

  Widget _passwordInput(BuildContext context) {
    return TextField(
      controller: password,
      obscureText: true,
      onChanged: (value) {},
    );
  }

  Widget _passwordDupInput(BuildContext context) {
    return TextField(
      controller: passwordDup,
      obscureText: true,
      onChanged: (value) {},
    );
  }

  Widget _registerButton(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, value, child) => Consumer<UserViewModel>(
        builder: (context, value2, child) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(150.w, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.w),
                )),
            onPressed: () async {

              if (oldPassword.text.isEmpty){
                setState(() {
                  oldPasswordNull = true;
                });
              } else {
                oldPasswordNull = false;
              }
              if (password.text.isEmpty) {
                setState(() {
                  passWordNull = true;
                });
              } else {
                passWordNull = false;
              }

              if (passwordDup.text.isEmpty) {
                setState(() {
                  dupPasswordNull = true;
                });
              } else {
                setState(() {
                  dupPasswordNull = false;
                });
              }

              if (passwordDup.text == password.text) {
                setState(() {
                  checkDupPassword = true;
                });
              } else {
                setState(() {
                  checkDupPassword = false;
                });
              }

              if(passwordDup.text.length<6 && password.text.length<6)
                {setState(() {
                  checkLengthPass = false;
                });
                } else {
                setState(() {
                  checkLengthPass = true;
                });
              }
              if(checkLengthPass ==false) {
                Fluttertoast.showToast(
                    msg: "Mật khẩu tối thiểu 6 ký tự",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }

              if (checkDupPassword == true && checkLengthPass ==true) {
                bool result =
                    await authViewModel.changePass(value2.user!.id!, oldPassword.text, passwordDup.text);


                print("???");
                print(result);
                if (result) {
                  // print("dung");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ProfilePage(),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Sai thông tin",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
            },
            child: Text(
              "Đổi mật khẩu",
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            )),
      ),
    );
  }

// Widget _createAccount(BuildContext context) {
//   return GestureDetector(
//     onTap: () {},
//     child: Text(
//       "Create a new account",
//       style: TextStyle(
//         fontSize: 14.sp,
//         color: const Color.fromARGB(255, 107, 107, 107),
//       ),
//     ),
//   );
// }
}
