import 'package:flutter/material.dart';
import 'package:projecthomestrategies/bloc/models/billimage_model.dart';
import 'package:photo_view/photo_view.dart';

class BillImagePresentation extends StatefulWidget {
  final int initialIndex;
  final List<BillImageModel> images;
  final bool useHeroAnimation;

  const BillImagePresentation({
    Key? key,
    this.initialIndex = 0,
    required this.images,
    this.useHeroAnimation = false,
  }) : super(key: key);

  @override
  State<BillImagePresentation> createState() => _BillImagePresentationState();
}

class _BillImagePresentationState extends State<BillImagePresentation> {
  late PageController controller;
  late int pageIndex;

  @override
  void initState() {
    super.initState();
    pageIndex = widget.initialIndex;
    controller = PageController(initialPage: widget.initialIndex);
  }

  void setPage(int newPage) {
    setState(() {
      pageIndex = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bilder"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: PageView.builder(
                itemCount: widget.images.length,
                controller: controller,
                onPageChanged: (newPage) => setPage(newPage),
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      heroAttributes: widget.useHeroAnimation
                          ? PhotoViewHeroAttributes(
                              tag: widget.images[index].billImageId!,
                            )
                          : null,
                      imageProvider: MemoryImage(widget.images[index].image!),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Indicators(
                imagesLength: widget.images.length,
                currentIndex: pageIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Indicators extends StatelessWidget {
  final int imagesLength;
  final int currentIndex;

  const Indicators(
      {Key? key, required this.imagesLength, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          imagesLength,
          (index) {
            return Container(
              margin: const EdgeInsets.all(3),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: currentIndex == index
                        ? Theme.of(context).primaryColor.withOpacity(0.7)
                        : Colors.black26,
                    blurRadius: 2,
                    spreadRadius: 2,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
