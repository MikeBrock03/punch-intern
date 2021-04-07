import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../helpers/app_localizations.dart';
import '../../../helpers/image_dialog.dart';

class LogoPicker extends StatefulWidget {

  final String imageURL;
  final Function() onTap;
  final bool enabled;
  final Function(String imageDir) onImageCaptured;
  final GlobalKey<ScaffoldState> globalKey;

  LogoPicker({ @required this.imageURL, this.onTap, this.onImageCaptured, this.globalKey, this.enabled = true });


  @override
  _LogoPickerState createState() => _LogoPickerState();
}

class _LogoPickerState extends State<LogoPicker> {

  final picker = ImagePicker();
  String _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageURL;
  }

  @override
  Widget build(BuildContext context) {
    return logoPickerBody();
  }

  Widget logoPickerBody(){
    return GestureDetector(
      onTap: (){
        if(widget.enabled){
          imageTap(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: _imageFile != null ? Image.file(
            File(_imageFile),
            width: double.infinity,
            fit: BoxFit.cover,
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.local_see, color: AppColors.normalText, size: 50),
              SizedBox(height: 5),
              Text(AppLocalizations.of(context).translate('company_logo'), style: TextStyle(color: AppColors.normalText, fontSize: 13))
            ],
          ),
        ),
      ),
    );
  }

  void imageTap(BuildContext cntx){
    FocusScope.of(cntx).unfocus();

    Future.delayed(Duration(milliseconds: 250), (){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return ImageDialog(
            globalKey: widget.globalKey,
            onGallery: () async{
              final pickedFile = await picker.getImage(source: ImageSource.gallery);

              setState(() async{
                if (pickedFile != null) {
                  String img = await imageCropper(imagePath: pickedFile.path);
                  widget.onImageCaptured(img);
                  _imageFile = img;
                } else {
                  print('No image selected.');
                }
              });
            },
            onCamera: () async{

              final pickedFile = await picker.getImage(source: ImageSource.camera);

              setState(() async{
                if (pickedFile != null) {
                  String img = await imageCropper(imagePath: pickedFile.path);
                  widget.onImageCaptured(img);
                  _imageFile = img;
                } else {
                  print('No image selected.');
                }
              });
            },
          );
        },
      );
    });
  }

  Future<String> imageCropper({ String imagePath }) async{
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio3x2,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          aspectRatioLockEnabled: true,
          minimumAspectRatio: 1.0,
          title: 'Cropper',
        )
    );
    return croppedFile.path;
  }
}
