import 'package:Connectify/screens/authentication_page.dart';
import 'package:Connectify/screens/home_page.dart';
import 'package:Connectify/screens/login_page.dart';
import 'package:Connectify/screens/signup_page.dart';
import 'package:Connectify/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGen{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=> const SplashScreen());
      case '/HomePage':
        if (args is String){
          return MaterialPageRoute(builder: (_)=> HomePage(title: args));
        }
        return _errorRoute('${settings.name}');
      case '/Signup':
        return MaterialPageRoute(builder: (_)=> SignUpScreen());
      case '/Login':
        return MaterialPageRoute(builder: (_)=> LoginScreen());
      case '/Auth':
        return MaterialPageRoute(builder: (_)=> AuthenticationScreen());
      default:
        return _errorRoute('${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String routeName){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: Center(
          child: Text('Error retrieving route: $routeName'),
        ),
      );
    });
  }
}