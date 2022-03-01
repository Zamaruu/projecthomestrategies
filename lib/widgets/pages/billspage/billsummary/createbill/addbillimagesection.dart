import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecthomestrategies/bloc/provider/new_bill_state.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/createbill/addbillimagecontainer.dart';
import 'package:projecthomestrategies/widgets/pages/homepage/panelheading.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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
      onPressed: () => _addImageModal(ctx),
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Bild hinzufügen"),
    );
  }

  void _addImageModal(BuildContext ctx) async {
    var pickedImages = await showModalBottomSheet<List<File>>(
      context: ctx,
      builder: (context) => const _AddMediaBottomSheet(),
    );

    var dir = await path_provider.getTemporaryDirectory();

    if (pickedImages != null) {
      List<Uint8List> temp = <Uint8List>[];

      for (var image in pickedImages) {
        var result = await FlutterImageCompress.compressWithFile(
          image.absolute.path,
          minWidth: 1920,
          minHeight: 1080,
          quality: 80,
        );

        print(image.lengthSync());
        print(result!.length);

        temp.add(result);
      }

      ctx.read<NewBillState>().addImageToList(temp);
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

class _AddMediaBottomSheet extends StatelessWidget {
  final double height = 130;

  const _AddMediaBottomSheet({Key? key}) : super(key: key);

  void _getFromGallery(BuildContext ctx) async {
    var pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null) {
      List<File> temp = <File>[];
      File tempFile;

      for (var image in pickedFiles) {
        tempFile = File(image.path);
        temp.add(tempFile);
      }

      Navigator.pop(ctx, temp);
    }
  }

  void _getFromCamera(BuildContext ctx) async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Navigator.pop(ctx, [imageFile]);
    }
  }

  ButtonStyle _buttonStyle(BuildContext ctx) {
    return OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      side: BorderSide(color: Theme.of(ctx).primaryColor.withOpacity(0.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: double.maxFinite,
            width: MediaQuery.of(context).size.width / 2.2,
            margin: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 10,
              right: 5,
            ),
            child: OutlinedButton.icon(
              onPressed: () => _getFromGallery(context),
              style: _buttonStyle(context),
              icon: const Icon(Icons.collections),
              label: const Text("Aus Gallerie"),
            ),
          ),
          Container(
            height: double.maxFinite,
            width: MediaQuery.of(context).size.width / 2.2,
            margin: const EdgeInsets.only(
              left: 5,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: OutlinedButton.icon(
              onPressed: () => _getFromCamera(context),
              style: _buttonStyle(context),
              icon: const Icon(Icons.photo_camera),
              label: const Text("Kamera"),
            ),
          ),
        ],
      ),
    );
  }
}
