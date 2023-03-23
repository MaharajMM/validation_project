import 'dart:convert';

import '../models/output_model.dart';
import 'package:http/http.dart' as http;

Future<OutputModel> testApi({
  required String text,
}) async {
  var headers = {
    'x-rapidapi-key': 'de94d3604fmsh124a897a5fc6e2ap115136jsn86e11b379074',
    'x-rapidapi-host': 'profanity-filter-by-api-ninjas.p.rapidapi.com',
  };
  const url = 'profanity-filter-by-api-ninjas.p.rapidapi.com';

  const endPoint = 'v1/profanityfilter';
  final queryParameters = {"text": text};
  final uri = Uri.https(url, endPoint, queryParameters);
  print(uri);
  final responseTest = await http.get(uri, headers: headers);
  print(responseTest.body);
  final source = jsonDecode(responseTest.body);
  return OutputModel.fromJson(source);
}
