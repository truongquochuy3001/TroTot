import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:tro_tot_app/views/register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();

   bool? emailNull ;
  bool? passWordNull;
  bool? isValid;
  bool? emailValidate;



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
                _titleText(context, "Welcome Back!",
                    "Nhập Email và mật khẩu để đăng nhập"),
                SizedBox(
                  height: 80.h,
                ),
                _inputLabel(context, "Email"),
                SizedBox(
                  height: 4.h,
                ),
                _userNameInput(context),
                emailNull == true ?  Text("Vui lòng nhập email", style: TextStyle(color: Colors.red, fontSize: 10.sp),): emailValidate == false ? Text("Email không hợp lệ", style: TextStyle(color: Colors.red, fontSize: 10.sp),) : const SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Mật khẩu"),
                passWordNull == true ?  Text("Vui lòng nhập mật khẩu", style: TextStyle(color: Colors.red, fontSize: 10.sp),): const SizedBox(),
                SizedBox(
                  height: 4.h,
                ),
                _passwordInput(context),
                SizedBox(
                  height: 60.h,
                ),
                Center(child: _loginButton(context)),

                SizedBox(
                  height: 40.h,
                ),
                Center(child: _createAccount(context)),
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

  Widget _userNameInput(BuildContext context) {
    return TextField(
      controller: email,
      onChanged: (value) {

      },
    );
  }

  Widget _passwordInput(BuildContext context) {
    return TextField(
      controller: password,
      obscureText: true,
      onChanged: (value) {

      },
    );
  }

  Widget _loginButton(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, value, child) => ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              fixedSize: Size(150.w, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              )),
          onPressed: () async {
            if (email.text.isEmpty)
              {
                setState(() {
                  emailNull = true;
                });
              }
            else {
              emailNull = false;
            }

            if (password.text.isEmpty)
            {
              setState(() {
                passWordNull = true;
              });
            }
            else {
              passWordNull = false;
            }
            if(EmailValidator.validate(email.text.toString()) == false)
              {setState(() {
                emailValidate = false;
              });}
            else {
              emailValidate = true;
            }


            bool result = await authViewModel.signIn(email.text, password.text) ;
            if (result)
              {
                setState(() {
                  isValid = true;
                });
              }
            else {
              setState(() {
                isValid = false;
              });
            }

            print(result);
            print(emailValidate);
            if (result && emailValidate!) {
              // print("dung");
              value.getUser(FirebaseAuth.instance.currentUser!.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListRoomPage(),
                ),
              );
            } else {
              Fluttertoast.showToast(
                  msg: "Sai thông tin đăng nhập",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );;
            }
          },
          child: Text(
            "Đăng nhập",
            style: TextStyle(color: Colors.white, fontSize:20.sp),
          )),
    );
  }

  Widget _createAccount(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterSreen(),));
      },
      child: Text(
        "Tạo tài khoản mới",
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color.fromARGB(255, 107, 107, 107),
        ),
      ),
    );
  }
}
