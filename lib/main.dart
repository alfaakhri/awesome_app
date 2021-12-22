import 'package:awesome_app/awesome_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:provider_module/providers/photos_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotosProvider>(
          create: (_) => PhotosProvider(repository: Repository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Awesome App',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: GoogleFonts.merriweather().fontFamily),
        initialRoute: SplashWidget.routeName,
        routes: {
          ListPhotosPage.routeName: (context) => const ListPhotosPage(),
          SplashWidget.routeName: (context) => const SplashWidget(),
          DetailPhotosPage.routeName: (context) => DetailPhotosPage(photos: Photos(),),
        },
      ),
    );
  }
}
