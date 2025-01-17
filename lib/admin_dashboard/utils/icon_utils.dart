import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

Icon getIconForCategory(String category) {
  switch (category) {
    case 'Education':
      return Icon(Icons.school);
    case 'Lifestyle':
      return Icon(Icons.self_improvement);
    case 'Healthcare':
      return Icon(Icons.local_hospital);
    case 'Housing':
      return Icon(Icons.house);
    case 'Food':
      return Icon(Icons.restaurant);
    case 'Transportation':
      return Icon(Icons.directions_car);
    case 'Childcare':
      return Icon(Icons.child_care);
    case 'Retirement':
      return Icon(Icons.access_time);
    case 'Unemployment':
      return Icon(Icons.work_off);
    case 'Veterans':
      return Icon(Icons.card_giftcard);
    case 'Social Support':
      return Icon(Icons.people);
    case 'Employment':
      return Icon(Icons.work);
    case 'Household':
      return Icon(Icons.home);
    default:
      return Icon(Icons.help_outline);
  }
}
