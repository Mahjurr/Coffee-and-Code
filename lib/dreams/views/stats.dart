import 'package:flutter/material.dart';
import 'package:units/dreams/Widgets/rounded_button.dart';
import '../utils/dreams_firebase.dart';
import '../utils/app_colors.dart' as AppColors;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class Stats extends StatefulWidget {
  final String? documentId = currentUser?.email;
  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  static Color backgroundColor = AppColors.darkBackground;
  String dropdownValue = 'Coffee Type';
  String dropdownTime = 'Select A Time';
  String dropdownSort = "Ascending";
  SortingOrder sortingOrder = SortingOrder.ascending;
  double roundDouble(num value) {
    return ((value * 100).round().toDouble() / 100);
  }
  static void statsSetBackgroundColor(bool tf){
    if(tf){
      backgroundColor = AppColors.darkBackground;
    }
    else{
      backgroundColor = Color(0xFFFBC02D);
    }
  }
  List<_CoffeeData> populateData(QuerySnapshot<dynamic> snapshot) {
    List<_CoffeeData> chartData = [];

    snapshot.docs.forEach((element) {
      var data = element.data();

      chartData.add(_CoffeeData(
        data['ageRange'],
        AppColors.lightAccent,
        codingHours: int.parse(data['codingHours']),
        coffeeCupsPerDay: int.parse(data['coffeeCupsPerDay']),
        codingWithoutCoffee: data["codingWithoutCoffee"],
        coffeeSolveBugs: data["coffeeSolveBugs"],
        coffeeType: data['coffeeType'],
        country: data['country'],
        gender: data['gender'],
        coffeeTime: data['coffeeTime'],
      ));
    });
    print(chartData);

    return chartData;
  }

  List<_CoffeeData> avgCodeAndCoffeeByAgeRange(List<_CoffeeData> data) {
    List<_CoffeeData> avgList = [];

    Set ageRanges = Set();
    data.forEach((element) {
      ageRanges.add(element.ageRange);
    });

    ageRanges.forEach((ageRange) {
      var ageRangeData =
          data.where((coffeeData) => coffeeData.ageRange == ageRange);
      num avgCoffeeCupsPerDay = 0;
      num avgCodingHours = 0;
      for (final item in ageRangeData) {
        avgCoffeeCupsPerDay += item.coffeeCupsPerDay;
        avgCodingHours += item.codingHours;
      }
      avgCoffeeCupsPerDay /= ageRangeData.length;
      avgCodingHours /= ageRangeData.length;

      avgList.add(_CoffeeData(ageRange, AppColors.lightAccent,
          coffeeCupsPerDay: roundDouble(avgCoffeeCupsPerDay),
          codingHours: roundDouble(avgCodingHours)));
    });

    avgList.sort((a, b) {
      return a.ageRange.compareTo(b.ageRange);
    });
    return avgList;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: FutureBuilder<QuerySnapshot>(
            future: getDataFromCoffeeType(dropdownValue, dropdownTime),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<Widget> children;

              if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Something went wrong'),
                  )
                ];
              }
              if (snapshot.hasData) {
                var coffeeData = populateData(snapshot.data!);
                var avgCoffeeData = avgCodeAndCoffeeByAgeRange(coffeeData);


                children = <Widget>[
                  DropdownButton(
                    value: dropdownValue,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: AppColors.darkBackgroundSecondary,
                    items: coffeeTypes_
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? coffeeType) async {
                      //query database
                      await getDataFromCoffeeType(coffeeType!, dropdownTime);
                      setState(() {
                        //this will populate the data because coffeeData is set in the future builder
                        dropdownValue = coffeeType;
                      });
                    },
                  ),

                  Row(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [

                      DropdownButton(
                        value: dropdownTime,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: AppColors.darkBackgroundSecondary,
                        items: coffeeTime_
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? coffeeTime) async {
                          //query database
                          await getDataFromCoffeeType(dropdownValue, coffeeTime!);
                          setState(() {
                            dropdownTime = coffeeTime;
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.all(16.0)),
                      DropdownButton(
                        value: dropdownSort,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: AppColors.darkBackgroundSecondary,
                        items: coffeeSort_
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? coffeeSort) async {
                          //query database
                          setState(() {
                            dropdownSort = coffeeSort!;
                            coffeeSort == "Ascending" ? sortingOrder = SortingOrder.ascending : sortingOrder = SortingOrder.descending;
                          });
                        },
                      ),
                    ],
                  ),

                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              borderColor: Colors.white,
                              title: AxisTitle(
                                  text: "Age Range",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                  text: "Coffee Cups And Coding Hours",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            title: ChartTitle(
                                text: '$dropdownValue',
                                textStyle: TextStyle(color: Colors.white)),
                            onLegendItemRender: (LegendRenderArgs args){
                              args.seriesIndex == 0 ? args.color = AppColors.lightAccent : args.color = Colors.brown;
                            },
                            legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                textStyle: TextStyle(color: Colors.white)),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_CoffeeData, String>>[
                              ColumnSeries<_CoffeeData, String>(

                                  dataSource: avgCoffeeData,
                                  xValueMapper: (_CoffeeData Coffee, _) =>
                                      Coffee.ageRange,
                                  yValueMapper: (_CoffeeData Coffee, _) =>
                                      Coffee.coffeeCupsPerDay,
                                  pointColorMapper: (_CoffeeData Coffee, _) =>
                                      Coffee.color,
                                  name: 'CoffeeCupsPerDay',
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(color: Colors.white))),
                              ColumnSeries<_CoffeeData, String>(
                                  dataSource: avgCoffeeData,
                                  xValueMapper: (_CoffeeData Coffee, _) =>
                                  Coffee.ageRange,
                                  yValueMapper: (_CoffeeData Coffee, _) =>
                                  Coffee.codingHours,
                                  pointColorMapper: (_CoffeeData Coffee, _) =>
                                  Colors.brown,
                                  name: 'CodingHours',
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(color: Colors.white)))
                            ]
                        ),
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              borderColor: Colors.white,
                              title: AxisTitle(
                                  text: "Coffee Cups Per Day",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                  text: "Coding Hours",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            // Chart title
                            title: ChartTitle(
                                text: '$dropdownValue',
                                textStyle: TextStyle(color: Colors.white)),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_CoffeeData, String>>[
                              ScatterSeries<_CoffeeData, String>(
                                  dataSource: coffeeData,
                                  xValueMapper: (_CoffeeData Coffee, _) =>
                                  Coffee.coffeeCupsPerDay.toString(),
                                  yValueMapper: (_CoffeeData Coffee, _) =>
                                  Coffee.codingHours,
                                  pointColorMapper: (_CoffeeData Coffee, _) =>
                                  Coffee.color,
                                  name: 'Cups : Hours',
                                  sortingOrder: sortingOrder,
                                  sortFieldValueMapper: (_CoffeeData Coffee, _) => Coffee.coffeeCupsPerDay,
                                  trendlines:<Trendline>[
                                    Trendline(
                                        type: TrendlineType.linear,
                                        color: AppColors.lightAccent
                                    )
                                  ]
                              )
                            ]
                        ),
                      ],
                    ),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }

              return
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  ),
                );

            }));
  }
}

class _CoffeeData {
  _CoffeeData(
    this.ageRange,
    this.color, {
    this.codingWithoutCoffee = "NA",
    this.coffeeSolveBugs = "NA",
    this.coffeeType = "NA",
    this.country = "Lebanon",
    this.gender = "NA",
    this.coffeeCupsPerDay = 0,
    this.codingHours = 0,
    this.coffeeTime = "NA",
  });
  @override
  String toString() {
    return "{ageRange: $ageRange, codingWithoutCoffee: $codingWithoutCoffee, coffeeSolveBugs: $coffeeSolveBugs, coffeeType: $coffeeType, country: $country, gender $gender, coffeeCupsPerDay: $coffeeCupsPerDay }";
  }

  final String ageRange;
  final String codingWithoutCoffee;
  final String coffeeSolveBugs;
  final String coffeeType;
  final String country;
  final String gender;
  final num coffeeCupsPerDay;
  final num codingHours;
  final String coffeeTime;
  final Color color;
}

const List<String> coffeeTypes_ = <String>[
  'Coffee Type',
  'American Coffee',
  'Caffè latte',
  'Cappuccino',
  'Double Espresso (Doppio)',
  'Espresso (Short Black)',
  'Nescafe',
  'Turkish',
];

const List<String> coffeeTime_ = <String>[
  'Select A Time',
  'While coding',
  'Before coding',
  'All the time'
];

const List<String> coffeeSort_ = <String>[
  "Ascending",
  "Descending",
];