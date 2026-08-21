import 'package:easy_get/widgets/atoms/loader_animation.dart';
import 'package:flutter/material.dart';

class AddDownloadSheetScaffold extends StatelessWidget {
  final Widget header;
  final Widget urlInput;
  final Widget detectSection;
  final Widget selectors;
  final Widget wifiOption;
  final bool isLoadingSubmit;
  final VoidCallback onSubmit;

  const AddDownloadSheetScaffold({
    super.key,
    required this.header,
    required this.urlInput,
    required this.detectSection,
    required this.selectors,
    required this.wifiOption,
    required this.isLoadingSubmit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.73,
      minChildSize: 0.4,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 25,
              children: [
                header,
                urlInput,
                detectSection,
                selectors,
                wifiOption,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    child: isLoadingSubmit
                        ? LoaderAnimation(size: 30.0, color: Theme.of(context).colorScheme.onPrimary)
                        : const Text('Iniciar descarga'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
