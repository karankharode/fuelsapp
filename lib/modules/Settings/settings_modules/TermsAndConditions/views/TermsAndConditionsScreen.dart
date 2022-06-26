import 'package:flutter/material.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';
import 'package:pdfx/pdfx.dart';
import 'package:performance/performance.dart';

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  static const int _initialPage = 1;
  bool _isEnglish = false;
  late PdfController _pdfController;
  ColorUtil colorUtil = ColorUtil();

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
        document: PdfDocument.openAsset('assets/Terms_Arabic.pdf'),
        initialPage: _initialPage,
        viewportFraction: 1);
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          style: TextStyle(fontSize: 12, color: colorUtil.white),
        ),
        backgroundColor: colorUtil.primaryRed,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfController,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          TextButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _isEnglish ? "عربي" : "English",
                style: TextStyle(fontSize: 12, color: colorUtil.white),
              ),
            ),
            onPressed: () {
              if (_isEnglish) {
                _pdfController.loadDocument(PdfDocument.openAsset('assets/Terms_Arabic.pdf'));
              } else {
                _pdfController.loadDocument(PdfDocument.openAsset('assets/Terms_Eng.pdf'));
              }
              _isEnglish = !_isEnglish;
              setState(() {});
            },
          ),
        ],
      ),
      body: CustomPerformanceOverlay(
        enabled: false,
        child: PdfView(
          builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
            pageLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
            pageBuilder: _pageBuilder,
          ),
          controller: _pdfController,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(
        pageImage,
        index,
        document.id,
      ),
      minScale: PhotoViewComputedScale.contained * 1,
      maxScale: PhotoViewComputedScale.contained * 2,
      initialScale: PhotoViewComputedScale.contained * 1.0,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}
