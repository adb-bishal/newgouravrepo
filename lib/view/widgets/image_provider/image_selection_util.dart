import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../model/utils/color_resource.dart';

class ImageSelectionUtil {
  final Function(XFile imageFile) _onImageGet;

  ImageSelectionUtil(this._onImageGet);

  showImagePicker(context) {
   // final KycController myProfileController = Get.find<KycController>();
    return 
    _openGallery();
    // showModalBottomSheet(
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     builder: (BuildContext bc) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeLarge,vertical: DimensionResource.marginSizeExtraLarge),
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(15),
    //             color: ColorResource.secondaryColor,
    //           ),
    //           child:  Wrap(
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 15),
    //                 child:  ListTile(
    //                     leading: const Icon(
    //                       Icons.photo_library,
    //                       color: ColorResource.white,
    //                     ),
    //                     title: const Text(
    //                       "Gallery",
    //                       style: TextStyle(color: ColorResource.white),
    //                     ),
    //                     onTap: () {
    //                       _openGallery();
    //                       Navigator.of(context).pop();
    //                     }),
    //               ),
    //               // Padding(
    //               //   padding: const EdgeInsets.only(left: 15),
    //               //   child:  ListTile(
    //               //     leading: const Icon(
    //               //       Icons.photo_camera,
    //               //       color: ColorResource.white,
    //               //     ),
    //               //     title: const Text("Camera",
    //               //         style: TextStyle(color: ColorResource.white)),
    //               //     onTap: () {
    //               //       _openCamera();
    //               //       Navigator.of(context).pop();
    //               //     },
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  void pickImageViaGallery(){
    _openGallery();
  }

  void pickImageViaCamera(){
    _openCamera();
  }
  void _openGallery() async {
    ImagePicker imagePicker = ImagePicker();

    try {
      XFile? imageFile = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);

      if(imageFile!= null){
        _onImageGet(imageFile);
      }
    } catch (e) {
     logPrint(e);
    }
  }

  void _openCamera() async {
    ImagePicker imagePicker = ImagePicker();

    try {
      XFile? imageFile = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 20);
      if(imageFile != null){

        _onImageGet(imageFile);
        logPrint(imageFile.mimeType.toString());
      }
    } catch (e) {
      logPrint(e);
    }
  }
}
