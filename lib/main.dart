import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projecthomestrategies/app_config_loader.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/filter_bills_state.dart';
import 'package:projecthomestrategies/bloc/provider/recipe_state.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:provider/provider.dart';
import 'bloc/models/bill_model.dart';
import 'bloc/models/billcategory_model.dart';
import 'bloc/provider/appcache_state.dart';
import 'bloc/provider/billing_state.dart';

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
          create: (context) => BillingState(
            <BillCategoryModel>[],
            <BillModel>[],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AppCacheState(
            [],
            [],
            [],
            [],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RecipeState(),
        ),
        ChangeNotifierProvider(
          create: (context) => BillFilterState(),
        ),
      ],
      child: const AppConfigLoader(),
    );
  }
}
