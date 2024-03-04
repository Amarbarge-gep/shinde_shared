import 'package:com_barge_idigital/screens/entryPoint/entry_point.dart';
import 'package:com_barge_idigital/screens/onboding/onboding_screen.dart';
import 'package:com_barge_idigital/services/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_pool/mongo_pool.dart';

void main() async {
  /// Create a pool of 5 connections
  final MongoDbPoolService poolService = MongoDbPoolService(
    const MongoPoolConfiguration(
      maxLifetimeMilliseconds: 900000,
      leakDetectionThreshold: 900000,
      uriString: 'as',
      poolSize: 4,
    ),
  );

  /// Open the pool
  await openDbPool(poolService);

  runApp(const MyApp());
}

Future<void> openDbPool(MongoDbPoolService service) async {
  try {
    await service.open();
  } on Exception catch (e) {
    /// handle the exception here
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthApi api = AuthApi();
    return MaterialApp(
      title: 'The IDigital',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      // home: const EntryPoint(
      //   inRouteName: "igenerate",
      //   data: null,
      // ),
      home: FutureBuilder(
        future: api.profile(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return const EntryPoint(
              inRouteName: "home",
              data: null,
            );
            // `_prefs` is ready for use.
          } else {
            return const OnbodingScreen();
          }
          // `_prefs` is not ready yet, show loading bar till then.
          //return CircularProgressIndicator();
        },
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
