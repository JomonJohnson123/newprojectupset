import 'package:flutter/material.dart';

Widget nameInput({
  required String name,
  required TextEditingController controller,
  required String label,
  required FormFieldValidator<String>? validator,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 24),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: name,
        contentPadding: const EdgeInsets.fromLTRB(30, 10, 30, 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    ),
  );
}

Widget qtyinput({
  required String name,
  required TextEditingController controller,
  required String label,
  required FormFieldValidator<String>? validator,
  required String hintText,
  double? width, // Added width parameter
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 24),
    child: SizedBox(
      width: width, // Set width using SizedBox
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: name,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 30, 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    ),
  );
}

Widget priceinput({
  required String name,
  required TextEditingController controller,
  required String label,
  required FormFieldValidator<String>? validator,
  required String hintText,
  double? width,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 24),
    child: SizedBox(
      width: width, // Set width using SizedBox
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: name,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 30, 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    ),
  );
}

Widget descriptionField({
  required String name,
  required TextEditingController controller,
  required String label,
  required FormFieldValidator<String>? validator,
  required String hintText,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 24),
    child: SizedBox(
      child: TextFormField(
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 30, 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        validator: validator, // Validation function
      ),
    ),
  );
}

class BuildTextFormField1 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;
  final FormFieldValidator<String>? validator;

  const BuildTextFormField1({
    required this.controller,
    required this.labelText,
    this.isMultiline = false,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 340,
        child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class BuildTextFormField2 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;
  final FormFieldValidator<String>? validator;

  const BuildTextFormField2(
      {super.key,
      this.validator,
      required this.controller,
      required this.labelText,
      this.isMultiline = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 340,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
