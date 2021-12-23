import 'package:flutter/material.dart';
import 'package:projecthomestrategies/utils/colortheme.dart';
import 'package:projecthomestrategies/widgets/basescaffold.dart/basescaffold.dart';
import 'package:provider/provider.dart';


class Homepage extends StatelessWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Startseite",
      body: Center(
        child: TextButton(
          onPressed: (){
            ColorThemes currentTheme = context.read<AppTheme>().currentTheme;
            if (currentTheme == ColorThemes.standard) {
              context.read<AppTheme>().changeTheme(ColorThemes.purple);
            } else {
              context.read<AppTheme>().changeTheme(ColorThemes.standard);
            }
          }, 
          child: const Text("Theme ändern"),
        ),
      )
    );
  }
}