import 'dart:io';

import 'package:http/http.dart' as http;

Future<http.Response> statusApi({required File imageFile}) async {
  const url = 'api.sightengine.com';

  const endPoint = '1.0/check.json';

  final queryParameters = {
    "api_user": 'api_user_id',
    "api_secret": 'api_sectre_id',
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
