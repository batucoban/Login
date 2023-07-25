import 'package:flutter/material.dart';
import 'package:login/core/service/firebase_service.dart';
import 'package:login/core/service/model/user/user_auth_error.dart';
import 'package:login/core/service/model/user/user_request.dart';
import 'package:login/ui/view/home/fire_home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  String? username;
  String? password;
  FirebaseService service = FirebaseService();

  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                onChanged: (value) {
                 setState(() {
                   username = value;
                 }); 
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username"
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                onChanged: (value) {
                 setState(() {
                   password = value;
                 }); 
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password"
                ),
              ),
              const SizedBox(height: 10,),
              FloatingActionButton.extended(onPressed: () async {
                var result = await service.postUser(UserRequest(email: username, password: password, returnSecureToken: true));
                if (result is FirebaseAuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hata')));
                }
                else{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FireHomeView()));
                }
              }, 
              label: const Text('Login'), 
              icon: const Icon(Icons.login),
              )
            ],
          ),
        ),
      ),
    );
  }
}

