import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String? hint;
  final String? Function(String?)? valid;
  final TextEditingController mycontroller;

  const AppTextField({
    super.key,
    required this.hint,
    required this.mycontroller,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      child: TextFormField(
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

validInput(String val, int min, int max) {
  if (val.isEmpty) {
    return "الحقل فارغ ";
  } else if (val.length < min) {
    return " يجب ان يون اكبر من  ${min} ";
  } else if (val.length > max) {
    return "يجب ان يكون اقصر من ${max} ";
  }
}
