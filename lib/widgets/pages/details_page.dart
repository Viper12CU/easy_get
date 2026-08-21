import 'package:easy_get/widgets/atoms/custom_icon_button.dart';
import 'package:easy_get/widgets/templates/details_template.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String heroTag;
  const DetailsPage({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomIconButton(icon: Icons.arrow_back_rounded, onTap: () {
            Navigator.pop(context);
          }),
        ),
        title: Text("Detalles de la descarga", style: Theme.of(context).textTheme.headlineSmall,)
      ),
      body: DetailsTemplate(heroTag: heroTag,),
    );
  }
}