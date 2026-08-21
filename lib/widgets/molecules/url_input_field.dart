import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  const UrlInputField({
    super.key,
    required this.formKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.0,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text('Enlace', style: theme.textTheme.labelSmall),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'https://example.com/archive.zip',
            ),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Este campo no puede estar vacío";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
