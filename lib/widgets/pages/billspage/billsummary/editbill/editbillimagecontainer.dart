import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/provider/edit_bill_state.dart';
import 'package:projecthomestrategies/utils/globals.dart';
import 'package:provider/provider.dart';

class EditBillImageContainer extends StatelessWidget {
  final Uint8List image;
  final int listIndex;

  const EditBillImageContainer({
    Key? key,
    required this.image,
    required this.listIndex,
  }) : super(key: key);

  String _getImageSizeInMegaByte() {
    return (image.length / 1000000).toStringAsFixed(2);
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
                    .read<EditBillState>()
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
    );
  }
}
