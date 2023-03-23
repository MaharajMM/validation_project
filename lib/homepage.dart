import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotted/flutter_dotted.dart';
import 'package:image_picker/image_picker.dart';

import 'constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Upload Photo",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getDeviceHeight(10),
                    ),
                    FlutterDotted(
                      color: Colors.grey,
                      gap: 5.0,
                      strokeWidth: 2.0,
                      child: GestureDetector(
                        onTap: () => pickImage(context),
                        child: Container(
                          height: getDeviceHeight(250),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              image != null
                                  ? Image.file(
                                      image!,
                                      width: getDeviceHeight(200),
                                      height: getDeviceHeight(200),
                                    )
                                  : const Icon(
                                      Icons.file_upload_outlined,
                                      size: 75,
                                    ),
                              // Text(
                              //   "Upload Photo of the campaign",
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     color: Colors.grey,
                              //     fontSize: 30,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /*TEXTFILES*/

                    SizedBox(height: getDeviceHeight(20)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "What do you want to tell the world?",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: getDeviceHeight(15)),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Write appropriate Caption',
                        //hintText: 'Phone No.',

                        border: OutlineInputBorder(),
                      ),
                    ),

                    /* IMAGE UPLOADING */

                    /*ELEVATED BUTTON => Done */

                    SizedBox(height: getDeviceHeight(30)),
                    SizedBox(
                      width: double.infinity,
                      height: getDeviceHeight(40),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Upload'.toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// You future
  late Future future;
//in the initState() or use it how you want...

  Future pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Hello This is FlutterCampus",
          ),
        ),
      );
      debugPrint('Failed to Pick image: $e');
    }
  }
}

// FutureBuilder(
//                       future: pickImage(context),
//                       builder: (context, snapshot) {
//                         switch (snapshot.connectionState) {
//                           case ConnectionState.none:
//                             return const Text('Please wait');
//                           case ConnectionState.waiting:
//                             return Center(child: CircularProgressIndicator());
//                           default:
//                             if (snapshot.hasError)
//                               return Text('Error: ${snapshot.error}');
//                             else {
//                               return image != null
//                                   ? Image.file(image!)
//                                   : Center(
//                                       child: Text("Please Get the Image"),
//                                     );
//                             }
//                         }
//                       },
//                     ),
