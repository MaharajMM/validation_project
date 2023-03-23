// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_dotted/flutter_dotted.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validation_project/models/output_model.dart';
import 'package:validation_project/api/testapi.dart';

import 'api/nudity_api.dart';
import 'constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  final TextEditingController _controller = TextEditingController();
  late Future<OutputModel> outputModel;
  bool hasProfanity = false;

  File? imageTemporary;

  @override
  Widget build(BuildContext context) {
    //String userInput = '';
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
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

                  //upload photo
                  FlutterDotted(
                    color: Colors.grey,
                    gap: 5.0,
                    strokeWidth: 2.0,
                    child: GestureDetector(
                      onTap: () async {
                        pickImage();
                      },
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
                            // Icon(
                            //   Icons.file_upload_outlined,
                            //   size: 75,
                            // ),

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
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: GestureDetector(
                      onTap: () => pickImage(),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.edit,
                            size: 35,
                          ),
                          Text(
                            'Change Image',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
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
                    //maxLines: 5,
                    //minLines: 2,
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: 'Write appropriate Caption',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _controller.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    // onChanged: (value) {
                    //   setState(() {});
                    // },
                  ),

                  SizedBox(height: getDeviceHeight(30)),
                  SizedBox(
                    width: double.infinity,
                    height: getDeviceHeight(40),
                    child: ElevatedButton(
                      onPressed: () async {
                        contentValidation();
                      },
                      child: Text(
                        'Upload'.toUpperCase(),
                      ),
                    ),
                  ),
                  SizedBox(height: getDeviceHeight(20)),
                  //Text(source.toString()),
                  // Text(
                  //    outputModel
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> nudityApi() async {
    final response = await statusApi(imageFile: image!);
    final source = jsonDecode(response.body) as Map<String, dynamic>;

    final status = source['status'];
    if (status == 'success') {
      final nudity = source['nudity'];
      //print('This is printing...$none');

      double none = nudity['none'];
      print('This is printing...$none');

      return none.toString();
    } else {
      return status;
    }
  }

  Future pickImage() async {
    try {
      final picImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (picImage != null) {
        setState(() {
          image = File(picImage.path);
          print(image);
        });
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No file selected"),
          ));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    // final picImage = await ImagePicker().pickImage(
    //   source: ImageSource.gallery,
    // );
    // if (picImage == null) return;
    // imageTemporary = File(picImage.path);
    // print(imageTemporary);
    // setState(() {
    //   image = imageTemporary;
    //   //print(image);
    // });

    String validateModel = await nudityApi();
    double myDouble = double.parse(validateModel);

    if (myDouble < 0.9) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          color: Colors.red,
          errorText: 'Your image contains nudity content. Try removing it.',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          color: Colors.green,
          errorText: 'Your image is safe. You can proceed.',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    }
  }

  Future contentValidation() async {
    OutputModel outputModel = await testApi(text: _controller.text);

    // String validateModel = await nudityApi();
    // double myDouble = double.parse(validateModel);

    if (outputModel.hasProfanity == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          color: Colors.red,
          errorText: 'Your content include some bad words. Try removing it.',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          color: Colors.green,
          errorText: 'Your content is safe. You can proceed.',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    }
  }
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.errorText,
    required this.color,
  });
  final String errorText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        height: getDeviceHeight(70),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text(
          errorText,
          style: const TextStyle(fontSize: 17),
        ));
  }
}
