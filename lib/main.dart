import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projecthomestrategies/app_config_loader.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:provider/provider.dart';
import 'bloc/provider/appcache_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomeStrategies());
}

class HomeStrategies extends StatelessWidget {
  const HomeStrategies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticationState(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppCacheState(
            [],
            [],
            [],
            [],
          ),
        ),
      ],
      child: const AppConfigLoader(),
    );
  }
}
