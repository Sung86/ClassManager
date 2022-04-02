import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'ClassManagement.dart';
import 'FullScreenText.dart';
import 'studentModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot)
      {
        if (snapshot.hasError) {
          return FullScreenText(text:"Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done)
        {
          return ChangeNotifierProvider(
              create: (context) => StudentModel(),
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Class Manager',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: ClassManagement()
              )
          );
        }
        return FullScreenText(text:"Loading");
      },
    );
  }
}


