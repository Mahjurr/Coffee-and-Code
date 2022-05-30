import 'package:flutter/material.dart';
//import 'package:units/dreams/utils/app_colors.dart' as AppColors;

import '../../utils/app_colors.dart';

class Event{
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightBlue,
    this.isAllDay = false,

  });
}
