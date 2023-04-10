// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
//
// class RegisterPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AuthViewModel auth = Provider.of<AuthViewModel>(context);
//     String email = "";
//     String password = "";
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             decoration: InputDecoration(
//               hintText: 'Email',
//             ),
//             onChanged: (value) => email = value,
//           ),
//           SizedBox(height: 20),
//           TextField(
//             obscureText: true,
//             decoration: InputDecoration(
//               hintText: 'Password',
//             ),
//             onChanged: (value) => password = value,
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 child: Text('Register'),
//                 onPressed: () async {
//                   var result = await auth.signIn(email, password);
//                   if (!result) {
//                     // Handle login failure
//                   }
//                 },
//               ),
//               ElevatedButton(
//                 child: Text('Login'),
//                 onPressed: () async {
//                   bool result = await auth.signUp(email, password);
//                   if (!result) {
//                     // Handle sign up failure
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
