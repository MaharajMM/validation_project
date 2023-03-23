import 'dart:io';

import 'package:http/http.dart' as http;

Future<http.Response> statusApi({required File imageFile}) async {
  const url = 'api.sightengine.com';

  const endPoint = '1.0/check.json';
  //const endPoint = {"api_user" : '659283247'};
  final queryParameters = {
    // "url":
    //     'https://titis.org/uploads/posts/2021-10/1634501532_34-titis-org-p-beautiful-nudity-erotika-39.jpg',
    "api_user": '659283247',
    "api_secret": 'z3g4M96zigv7z678A9ss',
    "models": 'nudity-2.0'
  };
  final uri = Uri.https(url, endPoint, queryParameters);
  // final responseTest = await http.get(uri);

  // return responseTest;

  final request = http.MultipartRequest('POST', uri);
  request.files.add(await http.MultipartFile.fromPath('media', imageFile.path));

  final responseTest = await http.Response.fromStream(await request.send());
  return responseTest;
}

//responseTest.files.add(await http.MultipartFile.fromPath('media', imageTemporary));
