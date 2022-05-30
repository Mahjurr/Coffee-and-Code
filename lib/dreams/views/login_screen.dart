import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/rounded_button.dart';
import 'package:flutter/material.dart';
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
    ));

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  var _error;
  bool _visible = false;
  bool showSpinner = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void changeErrorOnUI(String? errorCode, bool visible) {
    setState(() {
      switch (errorCode) {
        case 'wrong-password':
          {
            _error = "The password is incorrect";
          }
          break;
        case 'unknown':
          {
            _error = "Please enter an email and password";
          }
          break;
        case 'user-not-found':
          {
            _error = "Email not found";
          }
          break;
        case 'invalid-email':
          {
            _error = "Please enter a valid email address";
          }
      }
      _visible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, 56),
          child: Hero(
            tag: 'appBar',
            child: AppBar(
              title: Text("Log in"),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        backgroundColor: AppColors.darkBackground,
        //resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                    tag: 'appIcon',
                    child: Image.asset('lib/assests/images/CAC.png', color: AppColors.lightAccent)
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          onChanged: (value) {
                            email = value;
                            //Do something with the user input.
                          },
                          style: TextStyle(color: Colors.white, fontSize: 16),
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

                Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.textField,
                        borderRadius: new BorderRadius.circular(10.0),
                      ), 
                      child: TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          obscureText: true,
                          controller: _passwordController,
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
                              borderSide: BorderSide(color: AppColors.lightAccent, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            )
                          ),
                      )
                    )
                ),
                
                SizedBox(
                  height: 24.0,
                ),
                
                Hero(
                  tag: "Log in",
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.lightAccent,
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            _emailController.clear();
                            _passwordController.clear();
                            Navigator.pushNamed(context, 'home_screen');
                          }
                        } on FirebaseAuthException catch (e) {
                          print(e.message);
                          changeErrorOnUI(e.code, true);
                        }
                      }),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () async {
                      try {
                        await _auth.sendPasswordResetEmail(email: email);
                      } on FirebaseAuthException catch (e) {
                        print(e.message);
                        changeErrorOnUI(e.code, true);
                      }
                    },
                  ),
                Opacity(
                  opacity: _visible ? 1.0 : 0.0,
                  child: Text(
                    '$_error',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.red),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),)
              ],
            ),
          ),
        )
        
        );
  }
}
