import 'package:flutter/material.dart';

import '../home_screen.dart';

checkAuth(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => HomeScreen()));
}
