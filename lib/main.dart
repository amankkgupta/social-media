import 'package:flutter/material.dart';
import 'package:myminiblog/viewmodals/createpost_viewmodel.dart';
import 'package:myminiblog/viewmodals/editpost_viewmodel.dart';
import 'package:myminiblog/viewmodals/search_viewmodel.dart';
import 'package:myminiblog/views/about_view.dart';
import 'package:myminiblog/views/createpost_view.dart';
import 'package:myminiblog/views/edit_view.dart';
import 'package:myminiblog/views/home_view.dart';
import 'package:myminiblog/viewmodals/login_viewmodel.dart';
import 'package:myminiblog/viewmodals/post_viewmodel.dart';
import 'package:myminiblog/viewmodals/signup_viewmodel.dart';
import 'package:myminiblog/views/login_view.dart';
import 'package:myminiblog/views/posts_view.dart';
import 'package:myminiblog/views/profile_view.dart';
import 'package:myminiblog/views/search_view.dart';
import 'package:myminiblog/views/signup_view.dart';
import 'package:myminiblog/views/support_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> LoginViewModel()),
      ChangeNotifierProvider(create: (_)=> SignUpViewModel()),
      ChangeNotifierProvider(create: (_)=> PostViewModel()),
      ChangeNotifierProvider(create: (_)=> CreatePostViewModel()),
      ChangeNotifierProvider(create: (_)=> EditPostViewModel()),
      ChangeNotifierProvider(create: (_)=>SearchViewModel()),
    ],
    child: const MyApp(),
    )
  );
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/home':(context)=>HomeView(),
        '/login':(context)=>LoginPageView(),
        '/signup':(context)=>SignUpView(),
        '/posts':(context)=>PostListView(),
        '/createpost':(context)=>CreatePostView(),
        '/search':(context)=>SearchView(),
        '/profile':(context)=>ProfileView(),
        '/editpost':(context)=>EditPostView(),
        '/aboutus': (context)=>AboutPage(),
        '/support': (context)=>SupportPage()

      },
    );
  }
}