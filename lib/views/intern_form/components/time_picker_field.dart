import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class TimePickerField extends StatefulWidget {

  final Function(TimeOfDay timeOfDay) onTimePicked;
  final String hint;
  final String helpText;
  final bool enabled;

  TimePickerField({ this.onTimePicked, this.hint, this.helpText, this.enabled });

  @override
  _TimePickerFieldState createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {

  String selectedTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(widget.enabled){
          var time = await getSelectedTime(helpText: widget.helpText);
          setState(() {
            selectedTime = '${widget.hint}: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          });
          widget.onTimePicked(time);
        }
      },
      onLongPress: (){
        if(widget.enabled){
          setState(() {
            selectedTime = null;
          });
          widget.onTimePicked(null);
        }
      },
      child: Container(
        height: 53,
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[500],
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(child: Text(selectedTime != null ? selectedTime :widget.hint, style: TextStyle(fontSize: 14 ,color: selectedTime != null ? Colors.green[500] : Colors.grey[500]))),
      ),
    );
  }

  Future<TimeOfDay> getSelectedTime({ String helpText }){
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: helpText,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
              ),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
