import '../constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextArea extends StatefulWidget {

  final String labelText;
  final String value;
  final int maxLine;
  final TextInputAction inputAction;
  final Function(String term) onFieldSubmitted;
  final Function(String value) onValidate;
  final Function(String value) onChanged;
  final TextInputType textInputType;
  final bool isPassword;
  final TextDirection textDirection;

  AppTextArea({ this.maxLine, this.inputAction , this.onFieldSubmitted, this.onValidate, @required this.labelText, this.textInputType, this.isPassword, this.textDirection, this.value, this.onChanged});

  @override
  _AppTextAreaState createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {

  TextEditingController controller;
  bool isEmpty;
  bool isEnable = true;

  @override
  void initState() {
    super.initState();

    controller = new TextEditingController();
    isEmpty = controller.text.isEmpty;
    controller.addListener(() {
      if (isEmpty != controller.text.isEmpty) {
        setState(() {
          isEmpty = controller.text.isEmpty;
        });
      }
    });

    if(widget.value != null){
      controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(3),
      child: Directionality(
        textDirection: widget.textDirection != null ? widget.textDirection : TextDirection.rtl,
        child: TextFormField(
          controller: controller,
          enabled: isEnable,
          cursorColor: AppColors.primaryColor,
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          maxLines: widget.maxLine != null ? widget.maxLine : 5,
          textInputAction: widget.inputAction != null ? widget.inputAction : TextInputAction.next,
          autofocus: false,
          keyboardType: widget.textInputType != null ? widget.textInputType : TextInputType.multiline,
          obscureText: widget.isPassword != null ? widget.isPassword : false,
          onFieldSubmitted: (term){
            widget.onFieldSubmitted != null ? widget.onFieldSubmitted(term) : FocusScope.of(context).nextFocus();
          },
          onChanged: (value){
            widget.onChanged(value);
          },
          autocorrect: false,
          enableSuggestions: false,
          validator: (value) {
            return widget.onValidate != null ? widget.onValidate(value) : null;
          },
          decoration: InputDecoration(

            contentPadding: EdgeInsets.fromLTRB(0, 30, 20, 0),
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
            errorMaxLines: 1,
            errorStyle: TextStyle(fontSize: 11),
            border: OutlineInputBorder(
                borderSide:  BorderSide(color: AppColors.primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            focusedBorder:OutlineInputBorder(
                borderSide:  BorderSide(color: AppColors.primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            suffixIcon: controller.text.isNotEmpty ? GestureDetector( onTap: (){ controller.clear(); widget.onChanged(''); }, child: Icon(Icons.cancel, size: 21, color: Colors.grey[400])) : null,
          ),
        ),
      ),
    );
  }
}
