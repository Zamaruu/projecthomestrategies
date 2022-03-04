import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class EditBillImageContainer extends StatelessWidget {
  final BillImageModel image;
  final int listIndex;

  const EditBillImageContainer({
    Key? key,
    required this.image,
    required this.listIndex,
  }) : super(key: key);

  String _getImageSizeInMegaByte() {
    return (image.image!.length / 1000000).toStringAsFixed(2);
  }

  void _removeImage(BuildContext ctx) {
    ctx.read<EditBillState>().addImageToDelete(image.billImageId!);
    ctx.read<EditBillState>().removeImageFromList(listIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 200.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(image.image!),
        ),
      ),
      child: Selector<EditBillState, bool>(
        selector: (context, model) => model.isEditing,
        builder: (context, isEditing, _) {
          return Stack(
            children: [
              if (isEditing)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                      splashColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      splashRadius: Global.splashRadius,
                      onPressed: () => _removeImage(context),
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
          );
        },
      ),
    );
  }
}
