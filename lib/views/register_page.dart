import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
  TextEditingController passwordDup = TextEditingController();
  TextEditingController userName = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();
  UserViewModel userViewModel = UserViewModel();

  bool? userNameNull;

  bool? emailNull;
  bool? passWordNull;
  bool? isValid;
  bool? emailValid;
  bool? emailInUse;
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
                _titleText(context, "Đăng ký tài khoản",
                    "Nhập tên người dùng, email và mật khẩu"),
                SizedBox(
                  height: 80.h,
                ),
                _inputLabel(context, "Tên người dùng"),
                SizedBox(
                  height: 4.h,
                ),
                _userNameinput(context),
                userNameNull == true
                    ? Text(
                        "Vui lòng nhập tên người dùng",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                _inputLabel(context, "Email"),

                SizedBox(
                  height: 4.h,
                ),
                _emailInput(context),
                emailNull == true
                    ? Text(
                  "Vui lòng nhập email",
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                )
                    : emailValid == false
                    ? Text(
                  "email sai định dạng",
                  style:
                  TextStyle(color: Colors.red, fontSize: 14.sp),
                )
                    : const SizedBox(),
                emailInUse == true
                    ? Text(
                  "Email đã có người dùng",
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                )
                    : const SizedBox(),
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
                    : SizedBox(),
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
                    : checkDupPassword == false ? Text(
                  "Mật khẩu không trùng khớp",
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ) : const SizedBox(),

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

  Widget _passwordDupInput(BuildContext context) {
    return TextField(
      controller: passwordDup,
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
    return Consumer<AuthViewModel>(
      builder: (context, value, child) => ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              fixedSize: Size(150.w, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              )),
          onPressed: () async {
            bool emailValidate = EmailValidator.validate(email.text.toString());
            if (emailValidate) {
              setState(() {
                emailValid = true;
              });
            } else {
              setState(() {
                emailValid = false;
              });
            }

            if (userName.text.isEmpty) {
              setState(() {
                userNameNull = true;
              });
            } else {
              setState(() {
                userNameNull = false;
              });
            }

            if (email.text.isEmpty) {
              setState(() {
                emailNull = true;
              });
            } else {
              setState(() {
                emailNull = false;
              });
            }
            if (EmailValidator.validate(email.text.toString()) == false) {
              setState(() {
                emailValidate = false;
              });
            } else {
              emailValidate = true;
            }
            if (password.text.isEmpty) {
              setState(() {
                passWordNull = true;
              });
            } else {
              passWordNull = false;
            }

            if(passwordDup.text.isEmpty)
              {
                setState(() {
                  dupPasswordNull = true;
                });
              }
            else{
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

            bool emailAlreadyInUse =
                await value.isEmailAlreadyInUse(email.text);
            if (emailAlreadyInUse == false) {
              setState(() {
                emailInUse = false;
              });
              if (checkDupPassword == true) {
                bool result =
                    await authViewModel.signUp(email.text, passwordDup.text);
                if (result) {
                  setState(() {
                    isValid = true;
                  });
                } else {
                  isValid = false;
                }
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
              }
            } else {
              setState(() {
                emailInUse = true;
              });
            }
          },
          child: Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontSize: 22.sp),
          )),
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
