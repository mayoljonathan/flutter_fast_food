import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'viewmodels/cart_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartViewModel>(
      create: (_) => CartViewModel(),
      child: MaterialApp(
        title: 'Fast Food',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryIconTheme: IconThemeData(
            color: Colors.black87,
          ),
          canvasColor: Colors.white,
          fontFamily: 'Manrope',
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
