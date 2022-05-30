import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/dreams_firebase.dart';
import '../Widgets/rounded_button.dart';
import '../utils/app_colors.dart' as AppColors;


//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  //
  late String email;
  late String password;
  //
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 56),
        child: Hero(
          tag: 'appBar',
          child: AppBar(
            title: Text("Sign up"),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      backgroundColor: AppColors.darkBackground,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                        tag: 'appIcon',
                        child: Image.asset('lib/assests/images/CAC.png', color: AppColors.lightAccent)
                    ),

                    Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.textField,
                              borderRadius: new BorderRadius.circular(10.0),
                            ), 
                            child: TextFormField(
                                style: TextStyle(color: Colors.white, fontSize: 16),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  email = value;
                                  //Do something with the user input.
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(left: 20.0),
                                  labelText: 'Enter your email',
                                  labelStyle: TextStyle(color: AppColors.textFieldText, fontSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.lightAccent, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )
                                ),
                            )
                          )
                      ),


                    SizedBox(
                      height: 8.0,
                    ),

                    Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.textField,
                              borderRadius: new BorderRadius.circular(10.0),
                            ), 
                            child: TextFormField(
                                style: TextStyle(color: Colors.white, fontSize: 16),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  password = value;
                                  //Do something with the user input.
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(left: 20.0),
                                  labelText: 'Enter your password',
                                  labelStyle: TextStyle(color: AppColors.textFieldText, fontSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )
                                ),
                            )
                          )
                      ),


                    SizedBox(
                      height: 24.0,
                    ),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppColors.lightAccent,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser = await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                              if (newUser != null) {
                                addUser(email);
                                Navigator.pushNamed(context, 'home_screen');
                              }
                            } catch (e) {
                              print(e);
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          },
                    ),
                    Padding(padding: EdgeInsets.all(50),)
                  ],
                ),
          )
      )
    );
  }
}