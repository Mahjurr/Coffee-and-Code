import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dreams/services/notification_api.dart';
import 'dreams/services/notifications.dart';
import 'dreams/views/calendar.dart';
import 'dreams/views/welcome_screen.dart';
import 'dreams/views/home_screen.dart';
import 'dreams/views/signup_screen.dart';
import 'dreams/views/login_screen.dart';
import 'dreams/views/database_example.dart';
import 'dreams/views/video_resources.dart';
import 'firebase_options.dart';
import 'dreams/views/todo/todos.dart';
import 'dreams/views/todo/todo_home_page.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dreams/views/calendar/eventprovider.dart';
import 'dreams/views/calendar/homepage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}

late FirebaseMessaging messaging;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
  create: (context) => EventProvider(),//TodosProvider(),
   
  child: MaterialApp(
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => HomeScreen(),
        'database': (context) => DatabaseScreen(),
        'video_resources': (context) => VideoScreen(),
        //'CheckList':(context) => HomePage(),
        'Event Calendar':(context)=> MainPage(), //For calender event
      },
    ),  
  );

}
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}