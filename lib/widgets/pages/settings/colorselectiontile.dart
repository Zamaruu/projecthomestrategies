import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/authentication_state.dart';
import 'package:projecthomestrategies/bloc/provider/firebase_authentication_state.dart';
import 'package:projecthomestrategies/service/apiresponsehandler_service.dart';
import 'package:projecthomestrategies/service/settings_service.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/loading/loadingsnackbar.dart';
import 'package:projecthomestrategies/widgets/pages/settings/selectcolordialog.dart';
import 'package:provider/provider.dart';

class SelectColorTile extends StatelessWidget {
  const SelectColorTile({Key? key}) : super(key: key);

  Future<Color?> selectColorDialog(BuildContext ctx, Color currentColor) async {
    var color = await showDialog<Color>(
      context: ctx,
      builder: (context) {
        return SelectColorDialog(currentColor: currentColor);
      },
    );
    if (color != null) {
      await setColor(ctx, color);
    }
  }

  Future<void> setColor(BuildContext ctx, Color color) async {
    var token = await Global.getToken(ctx);
    var user = Global.getCurrentUser(ctx);

    user.color = color;
    user.userColor = color.value;

    var loader = LoadingSnackbar(ctx);
    loader.showLoadingSnackbar();

    var response = await SettingsService(token).editUser(
      user.userId!,
      user.userColor!,
    );

    loader.dismissSnackbar();

    if (response.statusCode == 200) {
      var model = ctx.read<FirebaseAuthenticationState>();
      var temp = model.sessionUser;
      temp.color = color;
      model.setUser(temp);
    } else {
      ApiResponseHandlerService.fromResponseModel(
        context: ctx,
        response: response,
      ).showSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthenticationState>(
      builder: (context, model, _) => ListTile(
        leading: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: model.sessionUser.color,
          ),
        ),
        title: const Text("Anzeigefarbe"),
        trailing: IconButton(
          tooltip: "Bearbeiten",
          onPressed: () async {
            await selectColorDialog(
              context,
              model.sessionUser.color!,
            );
          },
          splashRadius: Global.splashRadius,
          icon: const Icon(Icons.color_lens),
        ),
      ),
    );
  }
}
