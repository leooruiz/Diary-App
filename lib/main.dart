import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/async_study.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
  JournalService service = JournalService();
  service.getAll();
  asyncStudy();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          final Journal journal = settings.arguments as Journal;
          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(journal: journal);
            },
          );
        }
        return null;
      },
    );
  }
}
