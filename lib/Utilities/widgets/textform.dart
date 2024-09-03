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
