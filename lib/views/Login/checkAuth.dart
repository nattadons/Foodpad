import 'package:flutter/material.dart';

import '../home_screen.dart';

checkAuth(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, '/home_screen', (route) => false);
}
