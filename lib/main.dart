import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat/features/auth/data/repositories/auth_repository.dart';
import 'package:chat/shared/repositories/isar_db.dart';
import 'package:chat/shared/utils/abc.dart';
import 'package:chat/shared/utils/shared_pref.dart';
import 'package:chat/shared/utils/storage_paths.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'features/auth/views/welcome.dart';

import 'features/home/views/base.dart';
import 'firebase_options.dart';

import 'package:chat/theme/theme.dart';

Future<void> _StoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isDenied) {
    status = await Permission.storage.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _AudioPermission() async {
  var status = await Permission.audio.status;
  if (status.isDenied) {
    status = await Permission.audio.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _MediaPermission() async {
  var status = await Permission.mediaLibrary.status;
  if (status.isDenied) {
    status = await Permission.mediaLibrary.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _VideoPermission() async {
  var status = await Permission.videos.status;
  if (status.isDenied) {
    status = await Permission.videos.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _MicrophonrPermission() async {
  var status = await Permission.microphone.status;
  if (status.isDenied) {
    status = await Permission.microphone.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _ContactsPermission() async {
  var status = await Permission.contacts.status;
  if (status.isDenied) {
    status = await Permission.contacts.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _NotificationPermission() async {
  var status = await Permission.notification.status;
  if (status.isDenied) {
    status = await Permission.notification.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _ManageExternalStoragePermission() async {
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied) {
    status = await Permission.manageExternalStorage.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _AccessMediaLocationPermission() async {
  var status = await Permission.accessMediaLocation.status;
  if (status.isDenied) {
    status = await Permission.manageExternalStorage.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}

Future<void> _MediaLibraryPermission() async {
  var status = await Permission.mediaLibrary.status;
  if (status.isDenied) {
    status = await Permission.manageExternalStorage.request();
    if (status.isDenied) {
      // Handle the denied state
    }
  } else {}
}






// Future<void> _localAuthentication() async {
//   final _auth = LocalAuthentication();
//   bool canCheckBiometric = false;
//   try {
//     canCheckBiometric = await _auth.canCheckBiometrics;
//   } catch (e) {
//     canCheckBiometric = false;
//   }
//   bool hasAuthenticated = false;
//   try {
//     hasAuthenticated = await _auth.isDeviceSupported();
//   } catch (e) {
//     hasAuthenticated = false;
//   }

//   Future<bool> authenticate() async {
//     bool authenticated = false;
//     try {
//       authenticated = await _auth.authenticate(
//         localizedReason: 'Please authenticate to open the app',
//         // useErrorDialogs: true,
//         // stickyAuth: true,
//       );
//     } catch (e) {
//       authenticated = false;
//     }
//     return authenticated;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPref.init();
  await IsarDb.init();
  await DeviceStorage.init();
  await _StoragePermission();
  await _AudioPermission();
  await _ContactsPermission();
  await _NotificationPermission();
  await _VideoPermission();
  await _ManageExternalStoragePermission();
  await _AccessMediaLocationPermission();
  await _MediaPermission();
  await _MicrophonrPermission();
  await _MediaLibraryPermission();
  // await _localAuthentication();

  ErrorWidget.builder = (details) => CustomErrorWidget(details: details);
  return runApp(
    const ProviderScope(
      child: WhatsApp(),
    ),
  );
}

class WhatsApp extends ConsumerWidget {
  const WhatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Chat UP",
      initialRoute: '/',
      theme: ref.read(lightThemeProvider),
      darkTheme: ref.read(darkThemeProvider),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<auth.User?>(
        stream: ref.read(authRepositoryProvider).auth.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const WelcomePage();
          }

          final user = getCurrentUser();
          if (user == null) {
            return const WelcomePage();
          }

          return HomePage(user: user);
        },
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const CustomErrorWidget({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).custom.colorTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  color: colorTheme.appBarColor,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red[400],
                  size: 50,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorTheme.appBarColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'OOPS!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.red[400],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            details.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: colorTheme.blueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
