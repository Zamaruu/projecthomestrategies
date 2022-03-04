import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/createbill/addbillimagesection.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/editbill/editbillimagecontainer.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class EditBillImageSection extends StatelessWidget {
  const EditBillImageSection({Key? key}) : super(key: key);

  Widget _addImageButton(BuildContext ctx) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(90),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: BorderSide(color: Theme.of(ctx).primaryColor.withOpacity(0.5)),
      ),
      onPressed: () => _addImageModal(ctx),
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Bild hinzufügen"),
    );
  }

  void _addImageModal(BuildContext ctx) async {
    var pickedImages = await showModalBottomSheet<List<File>>(
      context: ctx,
      builder: (context) => const AddMediaBottomSheet(),
    );

    if (pickedImages != null) {
      List<BillImageModel> temp = <BillImageModel>[];

      for (var image in pickedImages) {
        var result = await FlutterImageCompress.compressWithFile(
          image.absolute.path,
          minWidth: 1920,
          minHeight: 1080,
          quality: 70,
        );

        print(image.lengthSync());
        print(result!.length);

        temp.add(BillImageModel(billImageId: 0, image: result));
      }

      ctx.read<EditBillState>().addImageToList(temp);
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
      child: Consumer<EditBillState>(
        builder: (context, state, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PanelHeading(
              heading: "Bilder",
              padding: 0,
              trailing: Text("${state.images.length} / ${state.maxImages}"),
            ),
            Consumer<EditBillState>(
              builder: (context, state, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EditBillImageContainer(
                      image: state.images[index],
                      listIndex: index,
                    );
                  },
                );
              },
            ),
            if (state.isEditing && state.images.length < state.maxImages)
              _addImageButton(context),
          ],
        ),
      ),
    );
  }
}
