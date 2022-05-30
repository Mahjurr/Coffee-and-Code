import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final auth = FirebaseAuth.instance;
User? currentUser;

Future<void> addUser(email) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  return users
      .doc(email)
      .set({
        'data': "User data goes here",
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

///Adds the given data to a firebase document with the current date as its document-ID
Future<void> addDataToDate(String key, dynamic data) {
  var date = DateTime.now();
  String monthDayYear = "${date.month}-${date.day}-${date.year}";
  String? email = currentUser!.email;
  CollectionReference dateCol = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('date');

  return dateCol
      .doc(monthDayYear)
      .set({'$key': data, 'date': monthDayYear}, SetOptions(merge: true,))
      .then((value) => print("Data added"))
      .catchError((error) => print("Failed to add data: $error"));
}

///Returns a QuerySnapshot containing all documents with the given coffeeType
Future<QuerySnapshot<Map<String, dynamic>>> getDataFromCoffeeType(String? coffeeType, String? coffeeTime) async{
  print('Querying coffeeType: $coffeeType');
  coffeeType == "Coffee Type" ? coffeeType = null : coffeeType;
  coffeeTime == 'Select A Time' ? coffeeTime = null : coffeeTime;
  return FirebaseFirestore.instance
      .collection('data')
      .where("coffeeType", isEqualTo: coffeeType)
      .where("coffeeTime", isEqualTo: coffeeTime).get();
}
Future<QuerySnapshot<Map<String, dynamic>>> getDataFromCoffeeTime(String? coffeeTime) async{
  print('Querying coffeeTime: $coffeeTime');
  coffeeTime == 'Select A Time' ? coffeeTime = null : coffeeTime;
  return FirebaseFirestore.instance
      .collection('data')
      .where("coffeeTime", isEqualTo: coffeeTime).get();
}

///Returns a QuerySnapshot containing all data after the given date
Future<QuerySnapshot<Map<String, dynamic>>> getDataFromDate(DateTime date) async{
  String monthDayYear = "${date.month}-${date.day}-${date.year}";
  print(monthDayYear);
  String? email = auth.currentUser!.email;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('date').where("date", isGreaterThan: monthDayYear).get();
}



void updateCurrentUser() async {
  try {
    final user = auth.currentUser;
    if (user != null) {
      currentUser = user;
      print("${currentUser!.email} logged in");
    }
  } catch (e) {
    print(e);
  }
}

///Converts a DateTime object to its weekday string
String dateTimeToWeekday(DateTime day){
  String weekday = '';
  switch(day.weekday){
    case 1:
      weekday = "Mon";
      break;
    case 2:
      weekday = "Tues";
      break;
    case 3:
      weekday = "Wed";
      break;
    case 4:
      weekday = "Thurs";
      break;
    case 5:
      weekday = "Fri";
      break;
    case 6:
      weekday = "Sat";
      break;
    case 7:
      weekday = "Sun";
      break;
  }
  return weekday;
}

///Converts a string "date" in the format month-date-year to a DateTime object
DateTime convertDateToDateTime(String date){
  String day = "";
  String month = "";
  String year = "";
  int j= 0;
  for(int i=0; i<date.length; i++) {
    var char = date[i];
    if (char == "-") {
      j++;
    }else {
      switch (j) {
        case 0:
          day += char;
          break;
        case 1:
          month += char;
          break;
        case 2:
          year += char;
          break;
      }
    }
  }
  DateTime dateTime = DateTime(int.parse(year), int.parse(day),int.parse(month));
  return dateTime;
}
