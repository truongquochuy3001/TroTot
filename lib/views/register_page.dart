import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tro_tot_app/models/user_model.dart';

import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:tro_tot_app/views/login_page.dart';

class RegisterSreen extends StatefulWidget {
  const RegisterSreen({Key? key}) : super(key: key);

  @override
  State<RegisterSreen> createState() => _RegisterSreenState();
}

class _RegisterSreenState extends State<RegisterSreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();
  UserViewModel userViewModel = UserViewModel();

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
                _titleText(
                    context, "Create account", "Enter your Email and Password"),
                SizedBox(
                  height: 80.h,
                ),
                _inputLabel(context, "UserName"),
                SizedBox(
                  height: 4.h,
                ),
                _userNameinput(context),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Email"),
                SizedBox(
                  height: 4.h,
                ),
                _emailInput(context),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Password"),
                SizedBox(
                  height: 4.h,
                ),
                _passwordInput(context),
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

  Widget _passwordInput(BuildContext context) {
    return TextField(
      controller: password,
      obscureText: true,
      onChanged: (value) {},
    );
  }

  Widget _userNameinput(BuildContext context) {
    return TextField(
      controller: userName,

      onChanged: (value) {},
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: Size(150.w, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.w),
            )),
        onPressed: () async {

          bool emailValidate = EmailValidator.validate(email.text.toString());

          bool result = await authViewModel.signUp(email.text, password.text);
          UserInfor user = UserInfor(name: userName.text);
          await userViewModel.addUser(user);

          print("???");
          print(result);
          if (result && emailValidate) {
            // print("dung");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else {
            const Text("Sai thong tin");
          }
        },
        child: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ));
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
