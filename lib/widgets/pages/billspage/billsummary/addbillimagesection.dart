import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecthomestrategies/bloc/provider/new_bill_state.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/addbillimagecontainer.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';

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
      onPressed: () => _getFromGallery(ctx),
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Bild hinzufügen"),
    );
  }

  void _getFromGallery(BuildContext ctx) async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // maxWidth: 1800,
      // maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      ctx.read<NewBillState>().addImageToList(imageFile);
    }
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
          Consumer<NewBillState>(
            builder: (context, state, _) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return AddBillImageContainer(
                    image: state.images[index],
                    listIndex: index,
                  );
                },
              );
            },
          ),
          _addImageButton(context),
        ],
      ),
    );
  }
}
