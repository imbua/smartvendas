import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:share_plus/share_plus.dart';
import 'package:smartvendas/shared/variaveis.dart';

class PagePreview extends StatefulWidget {
  final String inPdfDocFile;
  const PagePreview({Key? key, required this.inPdfDocFile}) : super(key: key);
// static const int _initialPage = 1;

  @override
  State<PagePreview> createState() => _PagePreviewState();
}

class _PagePreviewState extends State<PagePreview> {
  late pdfx.PdfController inPdfController;
  @override
  void initState() {
    inPdfController = pdfx.PdfController(
        document: pdfx.PdfDocument.openFile(widget.inPdfDocFile));
    super.initState();
  }

  @override
  void dispose() {
    inPdfController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // MediaQuery.of(context)
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // AppStore ctrlApp = Get.find<AppStore>();
    // final String _pdfDocFile =
    //     ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomAppBar(
        color: corText,
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.exit_to_app_sharp),
                onPressed: () {
                  // setState(() {
                  // dispose();
                  Navigator.pop(context);
                  // });
                },
              ),
              const Spacer(flex: 1),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  Share.shareFiles([widget.inPdfDocFile],
                      text: 'Segue o recibo');
                },
              ),
              const Spacer(flex: 2),
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () {
                  inPdfController.previousPage(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                  );
                },
              ),
              pdfx.PdfPageNumber(
                controller: inPdfController,
                builder: (_, loadingState, page, pagesCount) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    '$page/${pagesCount ?? 0}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  inPdfController.nextPage(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: pdfx.PdfView(
        builders: pdfx.PdfViewBuilders<pdfx.DefaultBuilderOptions>(
          options: const pdfx.DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          // pageBuilder: _pageBuilder,
        ),
        controller: inPdfController,
      ),
    );
  }

  // pdfx.PhotoViewGalleryPageOptions _pageBuilder(
  //   BuildContext context,
  //   Future<pdfx.PdfPageImage> pageImage,
  //   int index,
  //   pdfx.PdfDocument document,
  // ) {
  //   return pdfx.PhotoViewGalleryPageOptions(
  //     imageProvider: pdfx.PdfPageImageProvider(
  //       pageImage,
  //       index,
  //       document.id,
  //     ),
  //     minScale: pdfx.PhotoViewComputedScale.contained * 1,
  //     maxScale: pdfx.PhotoViewComputedScale.contained * 2,
  //     initialScale: pdfx.PhotoViewComputedScale.contained * 1.0,
  //     heroAttributes:
  //         pdfx.PhotoViewHeroAttributes(tag: '${document.id}-$index'),
  //   );
  // }
}
