import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';

class RegisterBlob extends StatelessWidget {
  final Function onTap;

  const RegisterBlob({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Blob.fromID(
          size: 220,
          id: const ['9-5-378830'],
          styles: BlobStyles(color: Theme.of(context).colorScheme.primary),
        ),
        Positioned(
          bottom: 5,
          child: Blob.fromID(
            id: const ['13-5-22246'],
            size: 175,
            styles: BlobStyles(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 38,
          child: Center(
            child: TextButton(
              onPressed: () => onTap(),
              child: const Text(
                "Noch kein Konto?",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
