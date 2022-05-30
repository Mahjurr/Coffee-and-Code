import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:provider/provider.dart';
import 'package:units/dreams/services/notification_api.dart';

import '../utils/dreams_firebase.dart';
import '../Widgets/rounded_button.dart';
import '../views/dreams_component.dart';
import '../presenter/dreams_presenter.dart';
import 'stats.dart';
import 'Log_Page.dart';
import 'resource_page.dart';
import '../utils/app_colors.dart' as AppColors;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../ad_helper.dart';
import 'calendar.dart';
import 'stats.dart';
import 'package:units/dreams/views/calendar/homepage.dart';
import 'calendar/eventprovider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    updateCurrentUser();
  }

  final screens = [
    Stats(),
    Home(),
    Log(),
  ];
  int currentIndex = 1;

  bool _lightThemeBool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text("Coffee & Code"),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        /*
        actions: <Widget>[
          Row(children: <Widget>[
            //Text("Log Out", style: const TextStyle(fontSize: 12)),
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
              },
            ),
          ])
        ],
        */
      ),
      endDrawer: Drawer(
        backgroundColor: AppColors.textField,
        child: ListView(children: <Widget>[
          Padding(padding: EdgeInsets.all(5)),
          Text("Settings",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'cursive',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Padding(padding: EdgeInsets.all(10)),
          SwitchListTile(
            title: Text("Light theme",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            value: _lightThemeBool,
            activeColor: AppColors.lightAccent,
            onChanged: (bool value) {
              setState(() => _lightThemeBool = value);
              /*
              * set background color of...
              * stats page
              * home page
              * log page              *
              * */
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.logout,
                size: 20,
                color: Colors.red,
              ),
              label: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ])
        ]),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.textField,
            showUnselectedLabels: false,
            fixedColor: AppColors.lightAccent,
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart, color: AppColors.lightAccent),
                label: "Stats",
                backgroundColor: Colors.brown,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: AppColors.lightAccent),
                label: "Home",
                backgroundColor: Colors.brown,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat, color: AppColors.lightAccent),
                label: "Journal",
                backgroundColor: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BannerAd _ad;

  bool _isAdLoaded = false;
  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        }));

    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _initGoogleMobileAds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [

              Expanded(child: HomePageButtons()),

              if(_isAdLoaded)
                Container(
                  child: AdWidget(ad: _ad),
                  height: _ad.size.height.toDouble(),
                  width: _ad.size.width.toDouble(),
                  alignment: Alignment.center,
                ),
            ]);
          } else {
            return HomePageButtons();
          }
        });
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
}

class HomePageButtons extends StatefulWidget {
  const HomePageButtons({Key? key}) : super(key: key);

  @override
  State<HomePageButtons> createState() => _HomePageButtonsState();
}

class _HomePageButtonsState extends State<HomePageButtons> {
  TimeOfDay selectedTime = TimeOfDay.now();
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // change the border color
              primary: AppColors.darkBackground,
              // change the text color
              onSurface: AppColors.darkBackground,
            ),
            // button colors
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.darkBackground,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
      return true;
    } else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
                tag: 'appIcon',
                child: Image.asset('lib/assests/images/CAC.png', color: AppColors.lightAccent, width: 225, height: 225)
            ),

            RoundedButton(
              colour: AppColors.textField,
              title: 'Video Resources',
              onPressed: () {
                Navigator.pushNamed(context, 'video_resources');
              },
            ),
            RoundedButton(
              colour: AppColors.textField,
              title: 'Event Calendar',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return MainPage();
                }));
              },
          ),
            
            RoundedButton(
              colour: AppColors.textField,
              title: 'Our Favorites',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ResourcePage();
                }));
              },
            ),
         RoundedButton(
          colour: AppColors.textField,
          title: 'Set Coding Alarm',
          onPressed: () async {
            if(await _selectTime(context) == true) {
              FlutterAlarmClock.createAlarm(
                  selectedTime.hour, selectedTime.minute);
            }
          }
        ),
      ]),
    );}
}

//Button Directory that leads us to the Resource Page
class ResourcePage extends StatefulWidget {
  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  @override
  Widget build(BuildContext context) {
    return new ResourcesPage(
      new BasicPresenter(),
      title: 'Coffee And Code',
      key: Key("UNITS"),
    );
  }
}
