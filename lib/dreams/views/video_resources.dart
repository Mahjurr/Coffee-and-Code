import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/rounded_button.dart';
import '../utils/app_colors.dart' as AppColors;

class VideoScreen extends StatefulWidget {
  @override
  _VideoResourcesState createState() => _VideoResourcesState();
}

class _VideoResourcesState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Coffee and Code Videos"),
        ),
        backgroundColor: AppColors.darkBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(
                    colour: AppColors.textField,
                    title: 'Starbucks Cold Brew',
                    onPressed: _SCBlaunchURL
                    ),
                RoundedButton(
                    colour: AppColors.textField,
                    title: 'Folgers French Press',
                    onPressed: _FFPlaunchURL
                    ),
                RoundedButton(
                    colour: AppColors.textField,
                    title: 'Crash Course: Computer Science',
                    onPressed: _CCCSlaunchURL
                    ),
                RoundedButton(
                    colour: AppColors.textField,
                    title: 'The Net Ninja: Flutter Tutorial',
                    onPressed: _NNFTlaunchURL
                    ),
                RoundedButton(
                    colour: AppColors.textField,
                    title: 'Traversy Media: Flutter Crash Course',
                    onPressed: _FCClaunchURL
                    ),
              ]),
        ));
  }
}

// ignore: non_constant_identifier_names
_SCBlaunchURL() async {
  const urlSCB = 'https://www.youtube.com/watch?v=An6LvWQuj_8';
  if (await canLaunch(urlSCB))
   {print("launching $urlSCB");
    await launch(urlSCB);}
  else {throw 'Could not launch maps';}
}

// ignore: non_constant_identifier_names
_FFPlaunchURL() async {
  const urlFFP = 'https://www.youtube.com/watch?v=D5VcMYP0GBY';
  if (await canLaunch(urlFFP))
  {print("launching $urlFFP");
  await launch(urlFFP);}
  else {throw 'Could not launch maps';}
}

// ignore: non_constant_identifier_names
_CCCSlaunchURL() async {
  const urlCCCS = 'https://www.youtube.com/watch?v=tpIctyqH29Q&list=PL8dPuuaLjXtNlUrzyH5r6jN9ulIgZBpdo';
  if (await canLaunch(urlCCCS))
  {print("launching $urlCCCS");
  await launch(urlCCCS);}
  else {throw 'Could not launch maps';}
}

// ignore: non_constant_identifier_names
_NNFTlaunchURL() async {
    const urlNNFT = 'https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ';
    if (await canLaunch(urlNNFT))
    {print("launching $urlNNFT");
  await launch(urlNNFT);}
  else {throw 'Could not launch maps';}
}

// ignore: non_constant_identifier_names
_FCClaunchURL() async {
  const urlFCC = 'https://www.youtube.com/watch?v=1gDhl4leEzA';
  if (await canLaunch(urlFCC))
  {print("launching $urlFCC");
  await launch(urlFCC);}
  else {throw 'Could not launch maps';}
}
