import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:projecthomestrategies/bloc/provider/new_recipe_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:projecthomestrategies/widgets/pages/billspage/billsummary/createbill/addbillimagesection.dart';
import 'package:provider/provider.dart';

class RecipeImageUpload extends StatelessWidget {
  const RecipeImageUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Selector<NewRecipeState, Uint8List?>(
        selector: (context, model) => model.image,
        builder: (context, image, _) {
          if (image != null) {
            return _ShowImage(image: image);
          } else {
            return const _UploadImage();
          }
        },
      ),
    );
  }
}

class _ShowImage extends StatelessWidget {
  final Uint8List image;

  const _ShowImage({Key? key, required this.image}) : super(key: key);

  String _getImageSizeInMegaByte() {
    return (image.length / 1000000).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(image),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 10,
            child: Material(
              borderRadius: BorderRadius.circular(50),
              child: IconButton(
                splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
                splashRadius: Global.splashRadius,
                onPressed: () => context.read<NewRecipeState>().removeImage(),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Material(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                //width: double.maxFinite,
                //height: 10,
                child: Text("${_getImageSizeInMegaByte()} MB"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadImage extends StatelessWidget {
  const _UploadImage({Key? key}) : super(key: key);

  void _addImageModal(BuildContext ctx) async {
    var pickedImages = await showModalBottomSheet<List<File>>(
      context: ctx,
      builder: (context) => const AddMediaBottomSheet(
        pickMultiple: false,
      ),
    );

    if (pickedImages != null) {
      var result = await FlutterImageCompress.compressWithFile(
        pickedImages.first.absolute.path,
        minWidth: 1920,
        minHeight: 1080,
        quality: 70,
      );

      if (result != null) {
        ctx.read<NewRecipeState>().setImage(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(90),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
      onPressed: () => _addImageModal(context),
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Bild hinzufügen"),
    );
  }
}
