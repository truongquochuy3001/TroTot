import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/views/home_page.dart';
import 'package:tro_tot_app/views/list_room_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthViewModel auth = Provider.of<AuthViewModel>(context);
    String email = "";
    String password = "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Email',
            ),
            onChanged: (value) => email = value,
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
            onChanged: (value) => password = value,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                  var result = await auth.signIn(email, password);
                  if (!result) {
                    // Handle login failure
                  } else {
                    // var get = auth.GetUser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListRoomPage()));
                  }
                },
              ),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () async {
                  bool result = await auth.signUp(email, password);
                  if (!result) {
                    // Handle sign up failure
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
