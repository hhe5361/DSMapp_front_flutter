import 'package:dasom_community_app/Provider/ArticleProvider.dart';
import 'package:dasom_community_app/Provider/AuthProvider.dart';
import 'package:dasom_community_app/Provider/BoardDetailProvider.dart';
import 'package:dasom_community_app/Provider/BoardProvider.dart';
import 'package:dasom_community_app/Provider/CalendarProvider.dart';
import 'package:dasom_community_app/Provider/CommentProvider.dart';
import 'package:dasom_community_app/Provider/DailyNewsProvider.dart';
import 'package:dasom_community_app/View/Page/AuthPage/LoginPage.dart';
import 'package:dasom_community_app/View/Page/AuthPage/RegisterPage.dart';
import 'package:dasom_community_app/View/Page/RoutePage.dart';
import 'package:dasom_community_app/util/mediasize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    medw = MediaQuery.of(context).size.width;
    medh = MediaQuery.of(context).size.height;

    return MultiProvider(
      providers: [
        //comment나 article 같은 경우에는 provider 뒤에 올려도 될 것 같음 . 수정 권고
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BoarderProvider()),
        ChangeNotifierProvider(create: (_) => BoardDetailProvider()),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => DailyNewsProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: MaterialApp(
        home: const LoginPage(),
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 255, 163, 163),
            useMaterial3: true),
        routes: {
          '/dashboard': (context) => const RoutePage(),
          '/login': (context) => const LoginPage(), //Login(),
          '/register': (context) => const RegisterPage() //Register(),
        },
      ),
    );
  }
}
