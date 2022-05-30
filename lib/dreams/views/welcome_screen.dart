import 'package:flutter/material.dart';
import '../Widgets/rounded_button.dart';
import '../utils/app_colors.dart' as AppColors;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, 56),
          child: Hero(
            tag: 'appBar',
            child: AppBar(
              //title: Text("Sweet Dreams"),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        backgroundColor: AppColors.darkBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(

              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Coffee And Code",
                  style: TextStyle(fontFamily: 'cursive', fontSize: 30, fontWeight: FontWeight.bold ,color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                //Image.asset('ic_launcher',
                // width: 600,height:300,
                //     fit: BoxFit.cover
                // ),
                Hero(
                    tag: 'appIcon',
                    child: Image.asset('lib/assests/images/CAC.png', color: AppColors.lightAccent)
                ),

                Padding(padding: EdgeInsets.all(50)),

                Hero(
                  tag: "Log in",
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.lightAccent,
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'login_screen');
                      },
                    ),
                ),
                Padding(padding: EdgeInsets.all(5),),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.brown,
                    side: BorderSide(width: 1.0, color: Colors.white,),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'registration_screen');
                  },
                ),
                Padding(padding: EdgeInsets.all(20),)
              ]),
        ));
  }
}
