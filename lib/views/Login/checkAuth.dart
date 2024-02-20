import 'package:flutter/material.dart';

checkAuth(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, '/home_screen', (route) => false);
}
