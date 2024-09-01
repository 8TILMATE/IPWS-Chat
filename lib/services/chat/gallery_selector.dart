import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GallerySelector extends ChangeNotifier
{
  Future pickImage(File? image) async 
  {
    try 
    {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      print(image.path);
    }
    
    on Exception catch(_){     
    }
  }
}

