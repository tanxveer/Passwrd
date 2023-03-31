import 'package:flutter/material.dart';
import 'package:password_manager/components/list_icon.dart';

class IdTile extends StatelessWidget {
  const IdTile(
      {Key? key,
      required this.companyName,
      required this.id,
      required this.copyTapped,
      this.listTapped})
      : super(key: key);

  final String companyName;
  final String id;
  final Function()? copyTapped;
  final Function()? listTapped;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: Colors.transparent,
      onTap: listTapped,
      textColor: Colors.white,
      leading: ListIcon(companyName: companyName),
      trailing: IconButton(
        onPressed: copyTapped,
        icon: const Icon(
          Icons.copy,
          color: Colors.white,
        ),
      ),
      title: Text(companyName),
      subtitle: Text(id),
    );
  }
}
