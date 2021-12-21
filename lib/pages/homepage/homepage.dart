import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/appbar.dart/customappbar.dart';
import 'package:projecthomestrategies/widgets/basescaffold.dart/basescaffold.dart';

class Homepage extends StatelessWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      pageTitle: "Startseite",
      body: Container()
    );
  }
}