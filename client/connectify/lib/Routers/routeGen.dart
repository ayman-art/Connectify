import 'package:Connectify/core/chat.dart';
import 'package:Connectify/screens/authentication_page.dart';
import 'package:Connectify/screens/chat_page.dart';
import 'package:Connectify/screens/contacts_page.dart';
import 'package:Connectify/screens/favouriteChats_page.dart';
import 'package:Connectify/screens/home_page.dart';
import 'package:Connectify/screens/login_page.dart';
import 'package:Connectify/screens/search_page.dart';
import 'package:Connectify/screens/signup_page.dart';
import 'package:Connectify/screens/splash_screen.dart';
import 'package:Connectify/screens/settings_page.dart';
import 'package:Connectify/screens/starred_page.dart';
import 'package:flutter/material.dart';

class RouteGen{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=> const SplashScreen());
      case '/HomePage':
        if (args is String){
          return MaterialPageRoute(builder: (_)=> HomePage());
        }
        return _errorRoute('${settings.name}');
      case '/Signup':
        return MaterialPageRoute(builder: (_)=> SignUpScreen());
      case '/Login':
        return MaterialPageRoute(builder: (_)=> LoginScreen());
      case '/Settings':
        return MaterialPageRoute(builder: (_)=> SettingsPage());
      case '/Auth':
        if (args is List<dynamic>){
          return MaterialPageRoute(builder: (_)=> AuthenticationScreen(args));
        }
        return _errorRoute('${settings.name}');
      case '/Contacts':
        return MaterialPageRoute(builder: (_)=> ContactsScreen());
      case '/Starred':
        return MaterialPageRoute(builder: (_)=> StarredMessagesScreen());
      case '/Favourite':
        return MaterialPageRoute(builder: (_)=> FavouriteScreen());
      case '/Search':
        return MaterialPageRoute(builder: (_)=> SearchMessagesScreen());
      case '/Chat':
        if (args is Chat){
          return MaterialPageRoute(builder: (_)=> ChatScreen(chat: args));
        }
        return _errorRoute('${settings.name}');
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