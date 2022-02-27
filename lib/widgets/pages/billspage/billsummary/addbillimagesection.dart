import 'package:flutter/material.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';

class NewBillImageSection extends StatelessWidget {
  const NewBillImageSection({Key? key}) : super(key: key);

  Widget _addImageButton(BuildContext ctx) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(90),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: BorderSide(color: Theme.of(ctx).primaryColor.withOpacity(0.5)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Bild hinzufügen"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeading(
            heading: "Bilder",
            padding: 0,
          ),
          _addImageButton(context),
        ],
      ),
    );
  }
}
