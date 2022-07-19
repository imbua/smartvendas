import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberEditCustom extends StatelessWidget {
  final TextInputType textInputType;
  final TextEditingController edController;
  final FocusNode? edFocusNode;
  final double fonteSize;
  final String caption;
  final double fieldSize;
  final double fieldWidth;
  final int textFlex;
  final int fieldMaxLength;
  final Function onComplete;
  const NumberEditCustom({
    Key? key,
    required this.caption,
    this.textInputType = TextInputType.text,
    this.textFlex = 3,
    required this.edController,
    this.edFocusNode,
    this.fonteSize = 12,
    this.fieldSize = 50,
    this.fieldWidth = 50,
    this.fieldMaxLength = 10,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    edController.text = caption;
    return Expanded(
      flex: textFlex,
      child: SizedBox(
        height: fieldSize,
        width: fieldWidth,
        // color: Colors.red,
        child: TextFormField(
          controller: edController,
          // initialValue: caption,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: Colors.black12),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            // labelText: caption,
          ),
          keyboardType: TextInputType.number,

          // maxLength: 5,
          style: TextStyle(fontSize: fonteSize),
          textInputAction: TextInputAction.next,

          onEditingComplete: () {
            onComplete();

            FocusScope.of(context).unfocus();
          },
          onTap: () {
            edController.text = caption;
            edController.selection = TextSelection(
                baseOffset: 0, extentOffset: edController.value.text.length);
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(fieldMaxLength),
          ],
        ),
      ),
    );
  }
}
