import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/billing_state.dart';
import 'package:projecthomestrategies/pages/billspage/billcategorydialog.dart';
import 'package:projecthomestrategies/widgets/billspage/addbillmodal.dart';
import 'package:provider/provider.dart';

class BillsSpeedDial extends StatelessWidget {
  final BuildContext providerContext;

  const BillsSpeedDial({Key? key, required this.providerContext})
      : super(key: key);

  SpeedDialChild customSpeedDialChild(
      {required String label,
      required IconData icon,
      required Function onTap}) {
    return SpeedDialChild(
      child: Icon(icon),
      backgroundColor: Colors.grey.shade700,
      labelBackgroundColor: Colors.grey.shade600,
      labelStyle: const TextStyle(color: Colors.white),
      foregroundColor: Colors.white,
      label: label,
      onTap: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      spacing: 3,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      renderOverlay: true,
      overlayColor: Colors.grey,
      overlayOpacity: 0.5,
      useRotationAnimation: true,
      tooltip: 'Rechnungsmenü',
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 8.0,
      isOpenOnStart: false,
      animationSpeed: 200,
      children: [
        customSpeedDialChild(
          label: "Neue Rechnung",
          icon: Icons.add,
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddBillModal();
            },
          ),
        ),
        customSpeedDialChild(
          label: "Kategorien",
          icon: Icons.list_alt_rounded,
          onTap: () {
            var household =
                context.read<AuthenticationState>().sessionUser.household;
            Navigator.of(providerContext).push(
              MaterialPageRoute(
                fullscreenDialog: false,
                builder: (providerContext) => const BillCategoriesDialog(),
              ),
            );
          },
        ),
        customSpeedDialChild(
          label: "Kostenanalyse",
          icon: Icons.analytics,
          onTap: () {},
        ),
      ],
    );
  }
}
