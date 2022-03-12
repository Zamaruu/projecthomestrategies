import 'dart:typed_data';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/new_bill_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';

import '../billimagepresentation.dart';

class AddBillImageContainer extends StatelessWidget {
  final Uint8List image;
  final int listIndex;

  const AddBillImageContainer({
    Key? key,
    required this.image,
    required this.listIndex,
  }) : super(key: key);

  String _getImageSizeInMegaByte() {
    return (image.length / 1000000).toStringAsFixed(2);
  }

  void _openImageView(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => BillImagePresentation(
          images: ctx
              .read<NewBillState>()
              .images
              .map((i) => BillImageModel(billImageId: 0, image: i))
              .toList(),
          initialIndex: listIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openImageView(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(minHeight: 150, maxHeight: 200.0),
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
                  onPressed: () => context
                      .read<NewBillState>()
                      .removeImageFromList(listIndex),
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
      ),
    );
  }
}
