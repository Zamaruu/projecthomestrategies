import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/user_model.dart';
import 'package:projecthomestrategies/widgets/globalwidgets/draweravatar.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final Function? onTap;
  final Widget? trailing;

  const UserTile({Key? key, required this.user, this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap != null ? () => onTap!() : null,
      leading: UserAvatar(
        firstLetter: user.firstname![0],
        avatarRadius: 45,
        color: user.color!,
        fontSize: 17.5,
        lastLetter: user.surname![0],
      ),
      title: Text("${user.firstname} ${user.surname}"),
      subtitle: Text(user.email!),
      trailing: trailing,
    );
  }
}
